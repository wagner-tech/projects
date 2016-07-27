#!/bin/bash
set -e

usage="insert_build.sh <file> <build>"

# inserts _<build> before last dot of filename
# example: "insert_build.sh 45 foo.pdf" leads to "foo_45.pdf"

if [ $# -ne 2 ]; then
	echo $usage
	exit 1
fi

stem=${1%.*}
ext=${1##*.}

cp $1 ${stem}_$2.$ext

