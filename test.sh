#!/bin/bash
source ./templates/.eiskrc

test_replace_characters() {
  result=$(replace_characters "Açãí  Fruit")
  assert_equals "$result" "acai-fruit"
}

assert_equals() {
  if [[ "$1" == "$2" ]]; then
      ((pass+=1))
      status=$'\e[32m✔'
  else
      ((fail+=1))
      status=$'\e[31m✖'
      local err="(\"$1\" != \"$2\")"
  fi

  printf ' %s\e[m | %s\n' "$status" "${FUNCNAME[1]/test_} $err"
}

# Generate the list of tests to run.
main() {
    IFS=$'\n'
    funcs=($(declare -F))
    for func in "${funcs[@]//declare -f }"; do
      [[ "$func" == test_* ]] && "$func";
    done

    comp="Completed $((fail+pass)) tests. ${greenb}${pass:-0} passed${end}, ${redb}${fail:-0} failed.${end}"
    printf '%s\n%s\n\n' "${comp//?/-}" "$comp"

    # If a test failed, exit with '1'.
    ((fail>0)) || exit 0 && exit 1
}

main "$@"
