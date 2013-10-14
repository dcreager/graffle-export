#!/usr/bin/python

# This is a batch wrapper for graffle.sh to allow a directory of .graffle files
# to be exported to eps or pdf formats. 

# Joel Bremson - jbremson - at - ucdavis - dot - edu. 
# 2013


__author__ = 'jbremson'

import sys
from os import listdir,getcwd, path, makedirs
from re import compile, IGNORECASE
from subprocess import call

def to_shell(cwd,format_type,input_dir,output_dir):
    loc = path.join(cwd,"graffle.sh")
    #loc += " %s %s %s" % (format_type,input_dir,output_dir)
    print loc
    call([loc,format_type,input_dir,output_dir])

    
if len(sys.argv) != 4:
    print """Wrong number of arguments. Should be 3.

    graffle-export.py <format> <input file or dir> <output file or dir>

    format must be either 'pdf' or 'eps'

    indicate a dir with a trailing /

    This script will convert all graffles in a directory to the chosen format
     in the output directory."""

    sys.exit()

cwd = getcwd()
format_type = sys.argv[1]
input_dir = path.abspath(sys.argv[2])
output_dir = path.abspath(sys.argv[3])

if format_type.lower() not in ['eps','pdf']:
    raise ValueError("Format must be either eps or pdf.")

regex = compile("\.graffle$",IGNORECASE)

try:
    infiles = filter(regex.search, listdir(input_dir))
except OSError:
    # directory does not exist - try passing the args straight to the shell script.
    to_shell(cwd,format_type,input_dir,output_dir)
    sys.exit()

if len(infiles)==0:
    # this is a straight pass through to graffle.sh because
    # no graffles were found in the file.
    # Note that a graffle is a dir, but it doesn't contain any graffles itself
    # (I hope). 
    print "No infiles."
    to_shell(cwd,format_type,input_dir,output_dir)
else:
    #input_dir is a directory with one or more files - send them to the same
    #file name in the output dir.

    #make sure it output dir exists.
    try:
        makedirs(output_dir)
    except OSError:
        if not path.isdir(output_dir):
            raise

    for infile in infiles:
        print "Converting ", infile , "..."
        inpath = path.join(input_dir,infile)
	outfile = infile.replace(".graffle",".%s" % format_type)
        outpath = path.join(output_dir,outfile)
        to_shell(cwd,format_type,inpath,outpath)




