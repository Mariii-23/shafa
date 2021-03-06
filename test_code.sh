#!/bin/bash

example_dir="$HOME/ficheiros-exemplo"
extension="shaf"

validate () {

    ./shafa "$1" -m c > /dev/null
    output=$( (valgrind ./shafa "$1" -m c >/dev/null) 2>&1 )

    if diff "$1.$extension" "$example_dir/$1.$extension"; then
      tput setaf 2; echo "FILES LOOK THE SAME" ;tput sgr0
    else
      tput setaf 1; echo "[WARNING] FILES ARE DIFFERENT [WARNING]" ; tput sgr0
    fi

    if  ! (echo "$output" | grep " 0 errors"); then
      tput setaf 1 ; echo "Valgrind found some errors." ; tput sgr0;
    fi
    if ! (echo "$output" | grep "no leaks are possible"); then
      tput setaf 1 ; echo "Valgrind found some memory leaks." ; tput sgr0;
    fi
}

declare -a files=("aaa.txt" "Shakespeare.txt" "bbb.zip" )

if make | grep "\*\*\*"; then
     tput setaf 1;echo "Error compiling" ; exit
else
    tput setaf 2 ; echo "Compiled succesfully" ; tput sgr0
fi

for file in "${files[@]}"
do
  echo "Testing for $file..."
  validate "$file"
  sleep 5s
  echo "Testing for $file.rle..."
  validate "$file.rle"
  sleep 5s;

done
