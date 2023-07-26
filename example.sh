trim () {
  grep -v -e ^-- -e '^$' -e '^SET ' -e '^SELECT ' || :
}

run () {
  local program=$1 ; shift
  local option=$1 ; shift
  local command=(
    "$program"
     --no-owner
     --no-privileges
     "$option"
  )
  [ $# -gt 0 ] && command+=( "$@" )

  printf '### `%s %s`\n' "$program" "$option"
  printf '\n'
  printf '```sql\n'
  "${command[@]}" | trim
  printf '```\n'
}

run pg_dump --schema-only

for option in '--schema-only' '--trigger=update_t1_updatetime'
do
  printf '\n'
  run pg_restore "$option" --file=- ${PGDATABASE}-dump.pg
done
