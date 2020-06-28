const express = require("express");
const bodyParser = require("body-parser");
const moment = require("moment");

const { selectArticlesAll, selectArticlesForUser, selectReadArticlesTimesForUser, insertArticlesEntry, insertReadArticlesEntry } = require("./sql-connection");
const { article_info } = require("./web-scraping");
const { categorize_article } = require("./key-phrases");

const app = express();
app.use(bodyParser.json({ strict: false, type: "*/*" }));

const serverPort = process.env.PORT || 8000;
const STREAK_MAXIMUM_ALLOWED_HOURS_BETWEEN_READ_EVENTS = 36;

//
//  Articles Collection
//
app.get("/articles", async (request, response) => {
    console.log(`[REQUEST] GET /articles`)
    try {
        response.send({
            Articles: formatArticles(await selectArticlesAll())
        });
    } catch (e) {
        console.error(e);
        response.status(500).end();
    }
});

app.post("/articles", async (request, response) => {
    console.log(`[REQUEST] POST /articles`)
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
    console.log(`[REQUEST] GET /users/:username/info`)
    try {
        const { username } = request.params;

        response.send({ StreakInDays: calculateStreak(await selectReadArticlesTimesForUser(username)) });
    } catch (e) {
        console.error(e);
        response.status(500).end();
    }
});

app.get("/users/:username/readArticles", async (request, response) => {
    console.log(`[REQUEST] GET /users/:username/readArticles`)
    try {
        const { username } = request.params;

        response.send({
            Articles: formatArticles(await selectArticlesForUser(username))
        });
    } catch (e) {
        console.error(e);
        response.status(500).end();
    }
});

app.post("/users/:username/readArticles", async (request, response) => {
    console.log(`[REQUEST] POST /users/:username/readArticles`)
    try {
        const { username } = request.params;

        const { ID: articleID } = request.body;
        const time = Date.now();
        
        const existingReadArticlesForUser = await selectArticlesForUser(username);
        if(existingReadArticlesForUser.some(a => a.ID == articleID)) {
            console.warn(`User ${username} has already read article with ID ${articleID}. Skipping.`)
            response.send();
            return;
        }

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
    const [title, imageURL] = await article_info(url);
    const category = await categorize_article(url);

    return {
        title: title.trim(),
        imageURL,
        category,
        date: Date.now()
    };
}

const calculateStreak = (timestamps) => {
    // Helper Function
    const calculateDaysAgo = (ts) => Math.ceil(moment.duration(moment().diff(moment.unix(ts))).asDays());

    // Quick Check
    if(timestamps.length === 0) {
        return 0;
    }

    // Calculate Differences Between Timestamps
    timestamps = timestamps.map(t => t.DateRead / 1000);
    timestamps.unshift(Date.now() / 1000);
    const timestampDiffs = timestamps.slice(1).map((ts, i) => timestamps[i] - ts);

    // Check for when Streak First Broken
    for (let i = 1; i < timestampDiffs.length; i++) {
        if (timestampDiffs[i] >= STREAK_MAXIMUM_ALLOWED_HOURS_BETWEEN_READ_EVENTS * 60 * 60) {
            // Streak Broken: Streak Exists Since timestamps[i]
            return calculateDaysAgo(timestamps[i]);
        }
    }

    // Streak Never Broken: Streak Exists Since First Timestamp
    return calculateDaysAgo(timestamps[timestamps.length - 1]);
}

const formatArticles = (articles) => {
    return articles.map(article => {
        article.Date = moment.unix(article.ArticleDate / 1000).fromNow();
        if(article.Date === "a few seconds ago") {
            article.Date = "just now";
        }
        delete article.ArticleDate;

        article.URL = article.ArticleURL;
        delete article.ArticleURL;

        article.Category = article.Category.toLowerCase();

        return article;
    });
};
