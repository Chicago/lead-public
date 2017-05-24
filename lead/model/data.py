from drain.step import Step
from drain import util, data
from drain.data import FromSQL, Merge
from drain.aggregation import SpacetimeAggregationJoin

from lead.features import aggregations
from lead.model.left import LeadLeft

from datetime import date
import pandas as pd
import numpy as np
import logging

class LeadData(Step):
    def __init__(self, month, day, year_min, year_max, wic_lag=None):
        Step.__init__(self, month=month, day=day, 
                year_min=year_min, year_max=year_max,
                wic_lag=wic_lag)

        acs = FromSQL(table='output.acs')
        acs.target = True

        left = LeadLeft(month=month, day=day, year_min=year_min)
        left.target = True

        dates = tuple((date(y, month, day) for y in range(year_min, year_max+1)))
        self.aggregations = aggregations.all_dict(dates, wic_lag)

        self.aggregation_joins = [
                SpacetimeAggregationJoin(inputs=[left, a], 
                lag = wic_lag if name.startswith('wic') else None,
                inputs_mapping=[{'aux':None}, 'aggregation']) 
            for name, a in self.aggregations.iteritems()]
        for aj in self.aggregation_joins: aj.target = True

        self.inputs = [acs, left] + self.aggregation_joins
        self.inputs_mapping=['acs', {}] + [None]*len(self.aggregations)

    def run(self, acs, left, aux):
        # join all aggregations
        logging.info('Joining aggregations')
        X = left.join([a.get_result() for a in self.aggregation_joins])
        # delete all aggregation inputs so that memory can be freed
        for a in self.aggregation_joins: del a._result

        logging.info('Joining ACS')
        # backfill missing acs data
        acs = acs.groupby('census_tract_id').apply(
                lambda d: d.sort_values('year', ascending=True)\
                    .fillna(method='backfill'))
        data.prefix_columns(acs, 'acs_', ignore=['census_tract_id'])

        # Assume ACS y is released on 1/1/y+2
        # >= 2017, use acs2015, <= 2012 use acs2010
        # TODO: use use 2009 after adding 2000 census tract ids!
        X['acs_year'] = X.date.dt.year.apply(lambda y: 
                min(2015, max(2010, y-2)))
        X = X.merge(acs, how='left', 
                on=['acs_year', 'census_tract_id'])
        X = X.drop('acs_year', axis=1)

        logging.info('Dates')
        X['age'] = (aux.date - aux.date_of_birth)/util.day
        X['date_of_birth_days'] = util.date_to_days(aux.date_of_birth)
        X['date_of_birth_month'] = aux.date_of_birth.dt.month
        X['wic'] = (aux.first_wic_date < aux.date).fillna(False)

        X.set_index(['kid_id', 'address_id', 'date'], inplace=True)
        aux.set_index(['kid_id', 'address_id', 'date'], inplace=True)

        c = data.non_numeric_columns(X)
        if len(c) > 0:
            logging.warning('Non-numeric columns: %s' % c)

        return {'X':X.astype(np.float32), 'aux':aux}
