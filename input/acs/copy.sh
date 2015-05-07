#!/bin/bash

filename=$1
tablename=`basename $filename | sed 's/_with_ann.csv//'`

sed 2d $filename | # remove second line (metadata)
sed 's/\(**\|-\|N\|(X)\|+\)//g' | # (remove missing value special chars
awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", "", $i) } 1' | # remove commas within double quotes
psql -v ON_ERROR_STOP=1 -c "COPY input.$tablename FROM STDIN WITH CSV HEADER;"
