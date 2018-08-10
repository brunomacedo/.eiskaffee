#!/bin/bash

# source ./tools/system.eisk
# source ./lib/alias.eisk
# source ./lib/npm.eisk
# source ./lib/git.eisk
source ./lib/colors.eisk
source ./tools/rename.eisk

test_replace_characters() {
  result=$(replace_characters "Açãí  Fruit")
  assert_equals "$result" "acai-fruit"
}

test_trim_string() {
  result=$(trim_string "   example string    ")
  assert_equals "$result" "example string"
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

    head="-> Running tests on the ${blueb}Eiskaffee...${end}"
    printf '\n%s\n%s\n' "$head" "${head//?/-}"

    IFS=$'\n'
    for func in $(declare -F); do
      [[ "${func:11}" == test_* ]] && "${func:11}";
    done

    comp="Completed $((fail+pass)) tests. ${greenb}${pass:-0} passed${end}, ${redb}${fail:-0} failed.${end}"
    printf '%s\n%s\n\n' "${comp//?/-}" "$comp"

    # If a test failed, exit with '1'.
    ((fail>0)) || exit 0 && exit 1
}

main "$@"
