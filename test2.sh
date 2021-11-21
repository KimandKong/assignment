#!/bin/bash

if ! options=$(getopt -o hp:n: -l help,path:,name:,aaa -- "$@")
then
   echo "ERROR: print usage"
   exit 1
fi

eval set -- $options 

while true; do
   case "$1" in
       -h|--help) 
           echo >&2 "$1 was triggered!"
           shift ;;
       -p|--path)    
           echo >&2 "$1 was triggered!, OPTARG: $2"
           shift 2 ;;   
       -n|--name)
           echo >&2 "$1 was triggered!, OPTARG: $2"
           shift 2 ;;
       --aaa)     
           echo >&2 "$1 was triggered!"
           shift ;;
       --)           
           shift 
           break
   esac
done

echo --------------------
echo "$@"
