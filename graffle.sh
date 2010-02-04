#!/bin/bash

if [ $# -eq 2 ]; then
    FORMAT=""
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

# Allow the user to specify the name of the OmniGraffle application in
# the GRAFFLE_APP environment variable.  If it is not set, then we
# must find a suitable default.  We determine this default by assuming
# that OmniGraffle is installed in /Applications, and use the
# Professional version if it exists.
if [ "x${GRAFFLE_APP}" == "x" ]; then
    APP=`ls -t /Applications | grep '^OmniGraffle Professional' | head -n 1`

    if [ "x${APP}" == "x" ]; then
        # Couldn't find a copy of OmniGraffle Pro.  Look for a copy of
        # Standard.

        APP=`ls -t /Applications | grep '^OmniGraffle' | head -n 1`

        if [ "x${APP}" == "x" ]; then
            # Couldn't find a copy of Standard, either.  That's an
            # error!

            echo <<EOF >&2
Couldn't find a copy of OmniGraffle (Pro or Standard) in
/Applications.  Please set the GRAFFLE_APP environment variable to the
name of OmniGraffle's application file.
EOF
            exit 1
        fi
    fi

    # If we fall through to here, $APP contains the directory name of
    # the OmniGraffle application.  We need to strip off the .app at
    # the end to get the application name.

    GRAFFLE_APP=`echo ${APP} | sed '/\.app$/s///'`
fi

echo $GRAFFLE_APP

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

#echo Format = $FORMAT
#echo Input = $INPUT_PATH
#echo Output = $OUTPUT_PATH

osascript $DIR/graffle.scpt "${GRAFFLE_APP}" "$FORMAT" "$INPUT_PATH" "$OUTPUT_PATH"
