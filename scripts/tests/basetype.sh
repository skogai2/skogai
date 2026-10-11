#!/usr/bin/env bash
# USAGE: basetype.sh <type> <input>
# string -> <type>: prints the value as that type, or fails
type="$1" input="$2"
here="$(dirname "$0")"
script="$here/basetype/$type.sh"
types="$here/../../config/types"
case "$type" in
  bool|int) git -c "skogai.input=$input" config get --type="$type" skogai.input; exit ;;
  string)   echo "$input"; exit ;;
esac
if [[ -x "$script" ]]; then
  "$script" "$input" || { echo "error: '$input' is not $type" >&2; exit 1; }
  echo "$input"
elif parts=$(git config get --file "$types" --all "type.$type" 2>/dev/null); then
  # a composed type: the input must be every one of its parts
  for part in $parts; do
    "$0" "$part" "$input" >/dev/null || { echo "error: '$input' is not $type" >&2; exit 1; }
  done
  echo "$input"
else
  echo "error: unknown type '$type'" >&2; exit 2
fi
