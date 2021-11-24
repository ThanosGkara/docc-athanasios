#!/usr/bin/env bash

## Exit on any error
set -e

RESULT=''
PRE_RESULT=''
## Check number of arguments given
if [[ $# -gt 1 ]]; then
  printf "Expected only 1 argument but %d given\n" $#
  printf "usage: %s 1113574\n" ${0##*/} >&2 ### Instead of using basename command POSIX shells
  exit 2
fi

### Bash string manipulations
#### https://tldp.org/LDP/abs/html/string-manipulation.html
#### https://www.baeldung.com/linux/bash-string-manipulation
#### http://www.softpanorama.org/Scripting/Shellorama/String_operations/index.shtml

## Assigning first argument to a variable
input=$1

## Iteration over first argument to produce the output
while [[ ${#input} -gt 0 ]]; do
  trimmed_by_1_input=${input#?}                ## new string trimmed missing its first digit
  current_digit="${input%$trimmed_by_1_input}" ## getting the trimmed digit

  ## Check if any provided digit is not a number
  if [[ -z "${current_digit##*[!0-9]*}" ]]; then
    printf "Given argument contains illegal char '%s'\n" $current_digit
    printf "usage: %s 1113574\n" ${0##*/} >&2 ### Instead of using basename command POSIX shells
    exit 2
  fi

  ## Creating the second part of the output
  case $current_digit in
  1)
    PRE_RESULT=$PRE_RESULT"PTF"
    ;;
  4)
    PRE_RESULT=$PRE_RESULT"ACC"
    ;;
  8)
    PRE_RESULT=$PRE_RESULT"BANK"
    ;;
  esac
  
  input=$trimmed_by_1_input ## reassigning the trimmed string to continue the loop 

done

if [[ $(expr $1 % 5) -eq 0 ]]; then
  RESULT=$RESULT"ACT"
elif [[ $(expr $1 % 7) -eq 0 ]]; then
  RESULT=$RESULT"BND"
elif [[ $(expr $1 % 9) -eq 0 ]]; then
  RESULT=$RESULT"CRYPT"
fi

printf "%s\n" $RESULT$PRE_RESULT
