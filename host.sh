#!/bin/bash

#### docker init
# install python
# install python requirement

python -m pip install -r requirements.txt

# install gcc cmake
# install cmark

#### jobs
# convert each markdown to .html content

pushd markdown
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
gunicorn --workers 2 app:app

