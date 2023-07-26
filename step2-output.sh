r () {
  pg_restore \
    --no-owner \
    --no-privileges \
    --file=${PGDATABASE}-"$@" ${PGDATABASE}-dump.pg
}

rf () {
  r full-"$@"
}

ri () {
  r itemized-"$@" \
    '--function=update_updatetime()' \
    --table=t1 \
    --trigger=update_t1_updatetime
}

r toc.txt --list

rf schema-only.sql --schema-only
rf data-only.sql   --data-only
rf pre-data.sql    --section=pre-data
rf data.sql        --section=data
rf post-data.sql   --section=post-data

ri schema-only.sql --schema-only
ri data-only.sql   --data-only
ri pre-data.sql    --section=pre-data
ri data.sql        --section=data
ri post-data.sql   --section=post-data
