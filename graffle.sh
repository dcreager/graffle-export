#!/bin/bash

# help text
usage="\
Usage: $0 [<option>...] <input file> <output file>

  Options:

    Long option         Short option    Description
    --canvas=NAME       -c NAME         Export selected canvas
    --border=NUM        -b NUM          Number of pixels of border area
    --size=NUM,NUM      -s NUM,NUM      Size of the manual export region
    --scale=NUM         -a NUM          The scale to use during export
    --resolution=NUM    -r NUM          Number of pixels per point (1.0 means 72 DPI)
    --transparent       -t              Leave the background transparent during export
    --include-border    -i              Include a border area
    --no-quit           -n              Do not quit OmniGraffle after export
    --help              -h              Print this text
    --quit                              Quit OmniGraffle and exit
"

# options
canvas_name=""
border="10"
size=""
scale="1.0"
resolution="1.0"
transparent=false
include_border=false
quit_graffle=true

dir=`dirname $0`

if [[ $# == 1 ]] && [[ "$1" =~ "--help|-h" ]] ; then
    echo "$usage" 1>&2
    exit 1
fi

if [[ $# == 1 ]] && [[ "$1" = "--quit" ]] ; then
    osascript $dir/quit-graffle.applescript
    exit 0
fi
# Parse arguments.
while [ $# -gt 2 ]; do
    case "$1" in
        --*=*)
            longopt=true
            opt=`echo "$1" | sed 's/=[-_a-zA-Z0-9]*//'`
            optarg=`echo "$1" | sed 's/[-_a-zA-Z0-9]*=//'`
            shift
            ;;
        *)
            longopt=false
            opt="$1"
            optarg="$2"
            shift
            shift
            ;;
    esac

    case "$opt" in
        --canvas=*|-c)
            canvas_name="$optarg"
            ;;
        --border=*|-b)
            border="$optarg"
            ;;
        --size=*|-s)
            size="$optarg"
            ;;
        --scale=*|-a)
            scale="$optarg"
            ;;
        --resolution=*|-r)
            resolution="$optarg"
            ;;
        --transparent|-t)
            transparent=true
            ;;
        --include-border|-i)
            include_border=true
            ;;
        --no-quit|-n)
            quit_graffle=false
            ;;
        --help|-h)
            echo "$usage" 1>&2
            exit 1
            ;;
    esac

    # unshift optarg for all options without parameter
    case "$opt" in
        --transparent|-t|--include_border|-i|--no-quit|-n)
            if [ $longopt = "false" ]; then
                set -- "$optarg" "$@"
            fi
            ;;
    esac
done

input_file="$1"
output_file="$2"

if [ -z "$input_file" -o -z "$output_file" ]; then
    echo "$usage" 1>&2
    exit 1
fi

if [ ! -f "$input_file" ]; then
    echo "input file does not exist"
    echo "$usage" 1>&2
    exit 1
fi

if [ -f "$output_file" ]; then
    echo "output file already exists"
    echo "$usage" 1>&2
    exit 1
fi

if [ ! "${input_file:0:1}" = "/" ] ; then
    # The input filename does not start with a slash, and is therefore
    # a relative pathname.  We need to prepend $PWD to get an absolute
    # path.
    input_file="$PWD/$input_file"
fi

if [ ! "${output_file:0:1}" = "/" ] ; then
    # The output filename does not start with a slash, and is
    # therefore a relative pathname.  We need to prepend $PWD to get
    # an absolute path.
    output_file="$PWD/$output_file"
fi

osascript $dir/graffle.applescript "$canvas_name" "$border" "$size" "$scale" "$resolution" "$transparent" "$include_border" "$input_file" "$output_file" "$quit_graffle"

