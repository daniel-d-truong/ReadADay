# API Docs

## General Notes

- On failure, a non-200-HTTP status code should be returned. This spec does not define the response body in the case of an error, so the HTTP status code should be checked before attempting to use the data.

## **Collection:** `/articles`

### ✳️ **GET** `/articles`: Retrieves a Feed

**Request Body:** N/A.

**Example Response Body:**

```json
{
    "Articles": [
        {
            "ID": 12345,
            "Title": "Some Title Here",
            "URL": "https://example.com/",
            "ImageURL": "https://example.com/image.png",
            "Date": "25 mins ago",
            "Category": "Education"
        },
        {
            "ID": 67890,
            "Title": "Some Title Here",
            "URL": "https://example.org/",
            "ImageURL": "https://example.org/image.png",
            "Date": "1 hour ago",
            "Category": "Sustainability"
        }
    ]
}
```

**Notes:**

- The `Date` field in the response should be rendered with a library similar to `Moment.js`.

### ✳️ **POST** `/articles`: Submits a New Article

**Request Body:**

- `URL` (type `string`). The URL of the article to submit.

**Example Request Body:**

```json
{
    "URL": "https://example.com/",
    "Username": 123
}
```

**Response Body:** None.

**Notes:**

- After adding this article, the server should mark it as read for the user specified in the request.

-----

## **Collection:** `/users`

### ✳️ **GET** `/users/{username}/info`: Retrieves Info for a User

**Request Body:** N/A.

**Example Response Body:**

```json
{
    "StreakInDays": 3
}
```

### ✳️ **GET** `/users/{username}/readArticles`: Retrieves the List of Read Articles by a User

This endpoint behaves **identically** to `GET /articles`, except the results are limited to the articles that a user has read.

**Note:** This should be in reverse chronological order of when a user has read an article.

### ✳️ **POST** `/users/{username}/readArticles`: Records that a User has Read an Article

**Request Body:**

- `ID` (type `integer`). The ID of the article a user has read.

**Example Request Body:**

```json
{
    "ID": 12345
}
```

**Response Body:** None.
