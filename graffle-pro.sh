#!/bin/bash

if [ $# -eq 2 ]; then
    FORMAT=pdf
    INPUT_FILE=$1
    OUTPUT_FILE=$2
elif [ $# -eq 3 ]; then
    FORMAT=$1
    INPUT_FILE=$2
    OUTPUT_FILE=$3
else
    PROG=`basename $0`
    echo "Usage: $PROG [<format>] <graffle file> <outputfile>"
    exit 1
fi

DIR=`dirname $0`

echo Format = $FORMAT
echo Input = $PWD/$INPUT_FILE
echo Output = $PWD/$OUTPUT_FILE

osascript $DIR/graffle.scpt "OmniGraffle Professional" "$FORMAT" "$PWD/$INPUT_FILE" "$PWD/$OUTPUT_FILE"
