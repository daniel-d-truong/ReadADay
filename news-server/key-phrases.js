'use strict';

let methods = {};

let https = require('https');
let webscrp = require('./web-scraping.js');
let consts = require('./consts.js');

let subscription_key = "399e1c979fa8438081324eeba25d8bf8";
let endpoint = "https://social-good-news.cognitiveservices.azure.com/";

let path = '/text/analytics/v2.1/keyPhrases';

/*
let response_handler = function (response) {
    let body = '';
    response.on('data', function (d) {
        body += d;
    });
    response.on('end', function () {
        let body_ = JSON.parse(body);
        let phrases = body_.documents[0].keyPhrases;
        let extras = body_.documents[1].keyPhrases;
        console.log(phrases.concat(extras))
        return phrases.concat(extras);
    });
    response.on('error', function (e) {
        console.log('Error: ' + e.message);
        return [];
    });
};
*/

let get_key_phrases = function (documents) {
    return new Promise(function(resolve, reject) {
        let body = JSON.stringify(documents);

        let request_params = {
            method: 'POST',
            hostname: (new URL(endpoint)).hostname,
            path: path,
            headers: {
                'Ocp-Apim-Subscription-Key': subscription_key,
            }
        };

        let req = https.request(request_params, function (response) {
            let body = '';
            response.on('data', function (d) {
                body += d;
            });
            response.on('end', function () {
                let body_ = JSON.parse(body);
                let phrases = body_.documents[0].keyPhrases;
                let extras = body_.documents[1].keyPhrases;
                console.log(phrases.concat(extras))
                resolve(phrases.concat(extras));
                // console.log(phrases)
                // resolve(phrases);
            });
            response.on('error', function (e) {
                console.log('Error: ' + e.message);
                resolve([]);
            });
        });
        req.write(body);
        req.end();
    })
}

methods.categorize_article = async function (url) {
    let res = await webscrp.web_scrape(url);
    let mainTitle = res[0];
    let titles = res[1].join(" ");
    let bodies = res[2].join(" ");

    let documents = {
        'documents': [
            { 'id': 'titles', 'language': 'en', 'text': titles},
            { 'id': 'bodies', 'language': 'en', 'text': bodies},
        ]
    };

    let keyPhrases = await get_key_phrases(documents);
    let matches = 0;
    for (var phrase of keyPhrases) {
        for (var key in consts.CATEGORIES) {
            if (consts.CATEGORIES.hasOwnProperty(key)) { 
                for (var word of consts.CATEGORIES[key]) {
                    if (phrase.toLowerCase().includes(word)) {
                        matches += 1;
                        console.log("---category match! phrase=" + phrase);
                        if (matches >= 3) {
                            console.log(mainTitle);
                            return key;
                        }
                        
                    }
                }
            }
        }
    }
    return ""
}

// for (var url of consts.ARTICLE_URLS) {
    // let url = 'https://www.nytimes.com/2020/06/27/us/politics/black-trans-lives-matter.html';
    // let url = 'https://www.wsj.com/amp/articles/masks-could-help-stop-coronavirus-so-why-are-they-still-controversial-11593336601';
    // methods.categorize_article(url).then(category => {
    //     console.log(category.toUpperCase() + "\n");
    //     return category;
    // }).catch(err => {
    //     console.log("n/a");
    //     return "";
    // })
// }

module.exports = methods;
