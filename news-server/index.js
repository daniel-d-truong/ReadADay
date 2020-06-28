  
const express = require("express");
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json({ strict: false, type: "*/*" }));

const serverPort = 8000;

const demoArticleData = {
    "Articles": [
        {
            "ID": 12345,
            "Title": "Some Title Here",
            "URL": "https://example.com/",
            "ImageURL": "https://zdnet3.cbsistatic.com/hub/i/2019/02/12/745b7ed1-f19c-4718-ad0b-ae7cb7a14fe9/fac8658d4aa5c4bcbda293ab3e1a3d3b/microsoft.png",
            "Date": "25 mins ago",
            "Category": "health"
        },
        {
            "ID": 67890,
            "Title": "Some Title Here adsfffffffffffdf asdfffffffffffffff",
            "URL": "https://example.org/",
            "ImageURL": "https://zdnet3.cbsistatic.com/hub/i/2019/02/12/745b7ed1-f19c-4718-ad0b-ae7cb7a14fe9/fac8658d4aa5c4bcbda293ab3e1a3d3b/microsoft.png",
            "Date": "1 hour ago",
            "Category": "sustainability"
        },
        {
            "ID": 67895,
            "Title": "Some Title Here",
            "URL": "https://example.org/",
            "ImageURL": "https://zdnet3.cbsistatic.com/hub/i/2019/02/12/745b7ed1-f19c-4718-ad0b-ae7cb7a14fe9/fac8658d4aa5c4bcbda293ab3e1a3d3b/microsoft.png",
            "Date": "1 hour ago",
            "Category": "civil rights"
        }
    ]
};

//
//  Articles Collection
//
app.get("/articles", (request, response) => {
    response.send(
        demoArticleData
    );
});

app.post("/articles", (request, response) => {
    const { URL: url, Username: username } = request.body;
    response.send(`[NOT YET IMPLEMENTED] Added article with URL ${url} and marked as read for user ${username}.`);
});

// 
//  Users Collection
//
app.get("/users/:username/info", (request, response) => {
    response.send({
        StreakInDays: 3
    });
});

app.get("/users/:username/readArticles", (request, response) => {
    response.send(demoArticleData);
});

app.post("/users/:username/readArticles", (request, response) => {
    const {username} = request.params;
    const {ID: articleID} = request.body;
    response.send(`[NOT YET IMPLEMENTED] Marked article with ID ${articleID} as read for user ${username}.`);
});

//
//  Start Server
//
app.listen(serverPort, () => console.log(`Server started on port ${serverPort}!`));