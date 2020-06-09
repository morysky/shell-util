#!/bin/zsh

GENESIS_INDEX="GENESIS_INDEX"

function red() {
    echo -e "\033[31m$1\033[0m"
}

function yellow() {
    echo -e "\033[33m$1\033[0m"
}

function green() {
    echo -e "\033[32m$1\033[0m"
}

function usage() {
    green "usage: building distributed table sql file [-t sql_template_filename] [-s total_size] [-c chunk_size] [-o sql-output-file]\nPlaceholder is [$GENESIS_INDEX]"
}

while {getopts t:s:c:o:vh arg} {
    case $arg {
        (t)
        TEMPLATE=$OPTARG
        ;;

        (s)
        SIZE=$OPTARG
        ;;

        (c)
        CHUNK=$OPTARG
        ;;
        
        (o)
        OUTPUT=$OPTARG
        ;;

        (v)
        echo version: 0.1
        ;;

        (h)
        usage
        ;;
    }
}

if [ X = "X"$TEMPLATE ]; then
    red "sql template is empty."
    exit 1
fi

if [ ! -f $TEMPLATE ]; then
    red "sql template file is not exist."
    exit 1
fi

if [ X = "X"$SIZE ]; then
    SIZE=`expr 128`
fi

if [ X = "X"$CHUNK ]; then
    SIZE=`expr 50`
fi

if [ X = "X"$OUTPUT ]; then
    OUTPUT="auto-build-sql.output"
fi

yellow "sql:[$TEMPLATE] size:[$SIZE] chunk:[$CHUNK] output:[$OUTPUT]"

rm -rf $OUTPUT

for ((i=0; i < $SIZE; i++)) {
    sed "s/$GENESIS_INDEX/$i/g" $TEMPLATE >> $OUTPUT
}
