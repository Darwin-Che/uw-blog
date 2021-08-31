# UW-Blog Structure Explain

In file `pages.meta`, each line represent a page, fields separated by whitespace(s) are in order 

```
// File "pages.meta"
// id filename prev next keyword1 keyword2 ...
```

And `prev`, `next` can be NULL if no matching id's are found. 

Keywords are provided for filtering the articles by categories, they are uniquely identified by the keyword string (case insensitive). 

