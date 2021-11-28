#!/usr/bin/env bash

## Exit on any error
set -e

## Creating if it does not exist, a results dir in the workdir to store the files created
WORKDIR=${PWD}/results
mkdir -p "$WORKDIR"

### Simple function to perform the operation on files
file_access () {
  ## Check if the file exists on order to create it
  if [ ! -f "$1" ]; then 
    echo "1" > "$1"
  else
    ## Read the value from the file and then we override it 
    echo $(expr $(<$1) + 1) > "$1"
  fi
}


## Check number of arguments given
if [[ $# -gt 1 ]]; then
  printf "Expected only 1 argument but %d given\n" $#
  printf "usage: %s 1113574\n" "${0##*/}" >&2 ### Instead of using basename command POSIX shells
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
    printf "Given argument contains illegal char '%s'\nArgument must contains integer only\n" "$current_digit"
    printf "usage: %s 1113574\n" "${0##*/}" >&2 ### Instead of using basename command POSIX shells
    exit 2
  fi

  ## Accessing the files in order to increment their value
  case $current_digit in
  1)
    file_access "$WORKDIR/PTF"
    ;;
  4)
    file_access "$WORKDIR/ACC"
    ;;
  8)
    file_access "$WORKDIR/BANK"
    ;;
  esac
  
  input=$trimmed_by_1_input ## reassigning the trimmed string to continue the loop 

done


## Accessing the files in order to increment their value
if [[ $(expr $1 % 5) -eq 0 ]]; then
  file_access "$WORKDIR/ACT"
elif [[ $(expr $1 % 7) -eq 0 ]]; then
  file_access "$WORKDIR/BND"
elif [[ $(expr $1 % 9) -eq 0 ]]; then
  file_access "$WORKDIR/CRYPT"
fi
