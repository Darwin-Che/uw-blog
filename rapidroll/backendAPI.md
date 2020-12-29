# Backend API Samples

## Endpoint

```
/rapidroll/data
```

## Methods

### GET

```
id: 12345678
```

```json
{
  "numprovided" : "150";
  "numleft" : "37";
	"content" : [
    {
      "id" : "12345679";
      "score" : "122";
      "quote" : "champion me dar!";
      "time" : "2021-01-12 12:00:00:000"
    },
    {
      "id" : "12350039";
      "score" : "122";
      "quote" : "champion me zer!";
      "time" : "2021-01-12 12:03:00:000"
    },
    {
      "id" : "12045679";
      "score" : "121";
      "quote" : "champion me lir!";
      "time" : "2021-01-12 12:05:00:000"
    },
    ...
  ]
}
```

or

```
score: 123
```

```json
{
	"tier" : "150"
}
```

### SET

```json
{
	"score" : "140";
	"quote" : "champion me nor!";
	"time" : "2021-01-12 13:10:00:000"
}
```

```json
{
	"id" : "12345698";
	"score" : "140";
	"quote" : "champion me nor!";
	"time" : "2021-01-12 13:10:00:000"
}
```



