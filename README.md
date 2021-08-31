# UW_BLOG

This repository is used to help manage my blog hosted by myself on a VPS. 

## Content

My blog posts consists of mainly technical notes in Markdown. 

So I uses the file `pages.meta` and the folder `markdown` to track the raw Markdown files, where each corresponds to a blog post. 

Because my notes can be scattered in different folders, I use `update.sh ${mynotesfolder}` to copy all Markdown files in that folder, and push the change / addition to `pages.meta` and `markdown`. The output will be a sequence of modified md files.

## Hosting

Used docker and my own image (darwinche/uw-blog ~ 500MB).

The docker container serves http content on port 5000 by gunicorn and flask.

To start the container, 
```
cd uw-blog
docker-compose build
docker-compose up
```

To stop the container,
```
cd uw-blog
docker-compose down
```

## Details of container

Step 1 : Use [`cmark`](https://github.com/commonmark/cmark "cmark") to convert Markdown files to html.

Step 2 : Use my script `gen_sum` to compute the title and pure text content of each html.

Step 3 : Init the Flask Application, which reads the `pages.meta` and result of `gen_sum` 
to obtain necessary info about the pages, then serve two kinds of templated endpoints : a list of posts, and one post.
