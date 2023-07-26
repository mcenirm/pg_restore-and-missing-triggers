set +x
set +e

exit_status=true

g () {
  local f=${PGDATABASE}-$1 ; shift
  if ! grep "$@" -- "$f"
  then
    (
      printf '!! grep check failed for file: %q\n++' "$f"
      printf ' %q' "$@"
      printf '\n'
    ) >&2
    exit_status=false
  fi
}

g toc.txt -F -e ' FUNCTION public update_updatetime() '
g toc.txt -F -e ' TABLE public t1 '
g toc.txt -F -e ' TABLE DATA public t1 '
g toc.txt -F -e ' TRIGGER public t1 update_t1_updatetime '

$exit_status
