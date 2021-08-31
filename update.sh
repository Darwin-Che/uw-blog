#!/bin/bash

# prompt and exit when wrong number of arguments
usage(){
	echo "Usage: ${0} directory of markdown files"
	exit 1
}

# only works with 2 arguments
if [ ${#} -ne 1 ]; then
	usage
fi

if [[ ${1} -eq "clear" ]]; then
    rm -f markdown/*
    rm -f pages.meta
    touch pages.meta
    echo "All Cleared"
    exit 0
fi

for f in $(ls ${1}); do
    # echo $f
    if [[ -f "markdown/${f}" ]]; then
        # echo -e "\t EXIST "
        diff "${1%/}/${f}" "markdown/${f}" > /dev/null
        if [[ ${?} = 0 ]]; then
            continue
            echo -e "\t EQUAL"
        fi
        # rm "${1%/}/${f}"
    fi
    cp "${1%/}/${f}" "markdown/${f}"
    echo ${f}
    echo -e "${f%.md}\t\t\tNULL\t\t\tNULL" >> pages.meta
done
