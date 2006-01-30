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

if echo "$INPUT_FILE" | grep '^/'; then
    # The input filename starts with a slash, and is therefore an
    # absolute pathname.  There is no need to prepend $PWD.
    INPUT_PATH=$INPUT_FILE
else
    # The input filename does not start with a slash, and is therefore
    # a relative pathname.  We need to prepend $PWD to get an absolute
    # path.
    INPUT_PATH=$PWD/$INPUT_FILE
fi

if echo "$OUTPUT_FILE" | grep '^/'; then
    # The output filename starts with a slash, and is therefore an
    # absolute pathname.  There is no need to prepend $PWD.
    OUTPUT_PATH=$OUTPUT_FILE
else
    # The output filename does not start with a slash, and is
    # therefore a relative pathname.  We need to prepend $PWD to get
    # an absolute path.
    OUTPUT_PATH=$PWD/$OUTPUT_FILE
fi

DIR=`dirname $0`

echo Format = $FORMAT
echo Input = $INPUT_PATH
echo Output = $OUTPUT_PATH

osascript $DIR/graffle.scpt "OmniGraffle Professional" "$FORMAT" "$INPUT_PATH" "$OUTPUT_PATH"
