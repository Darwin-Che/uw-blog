#!/bin/bash

#### docker init
# install python
# install python requirement

if ! command -v python &> /dev/null
then
    if ! command -v python3 &> /dev/null
    then
        echo "python or python3 could not be found"
        exit
    else
        python3 -m pip install -r requirements.txt
    fi
else
    python -m pip install -r requirements.txt
fi

# install gcc cmake
# install cmark

#### jobs
# convert each markdown to .html content

pushd markdown
mkdir -p ../content
for mdfile in *; do
    cmark < $mdfile > "../content/${mdfile%.md}.html"
done

# for each content, generate txt : oneline for title, oneline for text

popd
pushd gen_sum
gcc gen_sum.c -o gen_sum
./gen_sum ../content/*

# generate the structure and summary in python
# start flask

popd
# flask run --host=0.0.0.0
gunicorn -b 0.0.0.0:5000 --workers 2 app:app

