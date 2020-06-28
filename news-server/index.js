const express = require("express");
const bodyParser = require("body-parser");
const moment = require("moment");

const { selectArticlesForUser, selectArticlesAll, insertReadArticlesEntry, insertArticlesEntry } = require("./sql-connection.js")

const app = express();
app.use(bodyParser.json({ strict: false, type: "*/*" }));

const serverPort = 8000;

//
//  Articles Collection
//
app.get("/articles", async (request, response) => {
    try {
        response.send(formatArticles(await selectArticlesAll()));
    } catch(e) {
        console.error(e);
        response.status(500).end();
    }
});

app.post("/articles", async (request, response) => { 
    try {
        const { URL: articleURL, Username: username } = request.body;
        const { title, imageURL, date, category } = await getDataAboutArticle(articleURL);

        await insertArticlesEntry(title, articleURL, imageURL, date, category);
        response.send();
    } catch (e) {
        console.error(e);
        response.status(500).end();
    }
});

// 
//  Users Collection
//
app.get("/users/:username/info", async (request, response) => {
    try {
        const { username } = request.params;
        response.send({ StreakInDays: calculateStreak(await selectArticlesForUser(username)) });
    } catch(e) {
        console.error(e);
        response.status(500).end();
    }
});

app.get("/users/:username/readArticles", async (request, response) => {
    try {
        const { username } = request.params;
        response.send(formatArticles(await selectArticlesForUser(username)));
    } catch(e) {
        console.error(e);
        response.status(500).end();
    }
});

app.post("/users/:username/readArticles", async (request, response) => {
    try {
        const {username} = request.params;
        const {ID: articleID} = request.body;
        const time = Date.now();
        
        await insertReadArticlesEntry(username, articleID, time);
        response.send();
    } catch (e) {
        console.error(e);
        response.status(500).end();
    }
});

//
//  Start Server
//
app.listen(serverPort, () => console.log(`Server started on port ${serverPort}!`));


//
//  Utilities
//
const getDataAboutArticle = async (url) => {
    return {
        title: "Some Title Here",
        imageURL: "https://zdnet3.cbsistatic.com/hub/i/2019/02/12/745b7ed1-f19c-4718-ad0b-ae7cb7a14fe9/fac8658d4aa5c4bcbda293ab3e1a3d3b/microsoft.png",
        date: Date.now(),
        category: "Education"
    };
}

const calculateStreak = (timestamps) => {
    return 0;
}

const formatArticles = (articles) => {
    return articles.map(article => {
        article.Date = moment.unix(article.ArticleDate / 1000).fromNow();
        delete article.ArticleDate;

        article.URL = article.ArticleURL;
        delete article.ArticleURL;

        article.Category = article.Category.toLowerCase();

        return article;
    });
};