#### docker init
# install python
# install python requirement
# install c++ cmake
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
flask run


