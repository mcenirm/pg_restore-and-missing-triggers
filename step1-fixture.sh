createdb
psql --echo-queries --variable=ON_ERROR_STOP=1 --file=fixture.sql
pg_dump --format=directory --file=${PGDATABASE}-dump.pg
