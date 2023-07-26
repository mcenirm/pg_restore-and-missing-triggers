set +x
set +e

exit_status=true

c () {
  local f=${PGDATABASE}-$1 ; shift
  if ! grep -q "$@" -- 
  then
    (
      printf '!! grep check failed for file: %q\n++' "$f"
      printf ' %q' "$@"
      printf '\n'
    ) >&2
    exit_status=false
  fi
}

c toc.txt ' FUNCTION public update_updatetime() '
c toc.txt ' TABLE public t1 '
c toc.txt ' TABLE DATA public t1 '
c toc.txt ' TRIGGER public t1 update_t1_updatetime '

$exit_status
