r () { pg_restore --file=${PGDATABASE}-"$@" ${PGDATABASE}-dump.pg ; }
r toc.txt --list
