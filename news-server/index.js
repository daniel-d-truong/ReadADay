const express = require("express");
const bodyParser = require("body-parser");
const moment = require("moment");

const { selectArticlesAll, selectArticlesForUser, selectReadArticlesTimesForUser, insertArticlesEntry, insertReadArticlesEntry } = require("./sql-connection.js")

const app = express();
app.use(bodyParser.json({ strict: false, type: "*/*" }));

const serverPort = 8000;
const STREAK_MAXIMUM_ALLOWED_HOURS_BETWEEN_READ_EVENTS = 36;

//
//  Articles Collection
//
app.get("/articles", async (request, response) => {
    console.log(`>>> GET "/articles"`)
    try {
        response.send({
            Articles: formatArticles(await selectArticlesAll())
        });
    } catch(e) {
        console.error(e);
        response.status(500).end();
    }
});

app.post("/articles", async (request, response) => { 
    console.log(`>>> POST "/articles"`)
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
    console.log(`>>> GET "/users/:username/info"`)
    try {
        const { username } = request.params;

        const x = await selectReadArticlesTimesForUser(username);

        console.log(x);

        response.send({ StreakInDays: calculateStreak(x) });
    } catch(e) {
        console.error(e);
        response.status(500).end();
    }
});

app.get("/users/:username/readArticles", async (request, response) => {
    console.log(`>>> GET "/users/:username/readArticles"`)
    try {
        const { username } = request.params;
        response.send({
            Articles: formatArticles(await selectArticlesForUser(username))
        });
    } catch(e) {
        console.error(e);
        response.status(500).end();
    }
});

app.post("/users/:username/readArticles", async (request, response) => {
    console.log(`>>> POST "/users/:username/readArticles"`)
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
    return 1;
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