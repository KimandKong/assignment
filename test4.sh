#!/bin/bash

while getopts "a:b:c" opt; do
 case $opt in
   a)
     echo >&2 "-a 동작!, OPTARG: $OPTARG"
     ;;
   b)
     echo >&2 "-b 동작!, OpOPTARG: $OPTARG"
     ;;
   c)
     echo >&2 "-c 동작!"
     ;;
 esac
done

shift $(( OPTIND - 1 ))
echo ------------------
echo "$@"
