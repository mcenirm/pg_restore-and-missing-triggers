exit_status=true

check_x () {
  local n=$1
  local expected=$2
  local iftoc=$3
  local ifsql=$4
  local f=${PGDATABASE}-$n
  local actual=''
  local grep_args=()

  case "$n" in
    toc.txt) grep_args=( -F -e "$iftoc" ) ;;
    *.sql)   grep_args=(    -e "$ifsql" ) ;;
    *)
      printf >&2 'ERROR: Unexpected file type: %q\n' "$n"
      exit 99
      ;;
  esac

  if grep -q "${grep_args[@]}" -- "$f"
  then
    actual=Yes
  else
    actual=No
  fi

  if [ "$expected" = "$actual" ]
  then
    printf ' %s |' "$expected"
  else
    printf ' ~~%s~~<br>**%s** |' "$expected" "$actual"
    exit_status=false
  fi
}

check_function () {
  check_x "$@" \
    ' FUNCTION public update_updatetime() ' \
    '^CREATE FUNCTION public\.update_updatetime() '
}

check_table () {
  check_x "$@" \
    ' TABLE public t1 ' \
    '^CREATE TABLE public\.t1 '
}

check_data () {
  check_x "$@" \
    ' TABLE DATA public t1 ' \
    '^COPY public\.t1 '
}

check_trigger () {
  check_x "$@" \
    ' TRIGGER public t1 update_t1_updatetime ' \
    '^CREATE TRIGGER public\.update_t1_updatetime '
}

cat <<EOF
| File | Function | Table | Data | Trigger |
| ---- | -------- | ----- | ---- | ------- |
EOF
while IFS=, read -r File Function Table Data Trigger
do
  printf '| %q |' "$File"
  check_function "$File" "$Function"
  check_table    "$File" "$Table"
  check_data     "$File" "$Data"
  check_trigger  "$File" "$Trigger"
done < $(head -n+2 expected.csv)

$exit_status
