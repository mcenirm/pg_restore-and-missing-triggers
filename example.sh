separator=''
heading () {
  local first=$1 ; shift
  printf "$separator"
  printf '### `%s' "$first"
  if [ $# -gt 0 ]
  then
    printf ' %s' "$@"
  fi
  printf '`\n'
  printf '\n'
  separator='\n'
}

sqlblock () {
  printf '```sql\n'
  "$@" | (grep -v -e ^-- -e '^$' -e '^SET ' -e '^SELECT ' || :)
  printf '```\n'
}

dump () {
  heading "pg_dump $*"
  sqlblock pg_dump --no-owner --no-privileges "$@"
}

restore () {
  heading "pg_restore $*"
  sqlblock pg_restore --no-owner --no-privileges --file=- "$@" --file=- ${PGDATABASE}-dump.pg
}

query () {
  heading "psql $*"
  sqlblock psql "$@"
}

table () {
  heading "psql $*"
  psql --html "$@"
}

dump    --schema-only
restore --schema-only
table -c '\df'
table -c '\dt'
table -c '\dy'
query -c '\sf update_updatetime()'
table -c '\d t1'

options=(
  --section=pre-data
  --section=post-data
  '--schema-only --function=update_updatetime()'
  '--schema-only --table=t1'
  '--schema-only --trigger=update_t1_updatetime'
)
for option in "${options[@]}"
do
  restore $option
done
