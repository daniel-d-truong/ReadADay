CREATE TABLE ReadArticles (
    ID int IDENTITY(1,1) PRIMARY KEY,
    ArticleID int,
    DateRead bigint,
    Username nvarchar(255)
);

CREATE TABLE Articles (
    ID int IDENTITY(1,1) PRIMARY KEY,
    Title nvarchar(500),
    ArticleURL nvarchar(500),
    ImageURL nvarchar(500),
    ArticleDate bigint,
    Category nvarchar(255)
);