'use strict';

let https = require ('https');

let subscription_key = "399e1c979fa8438081324eeba25d8bf8";
let endpoint = "https://social-good-news.cognitiveservices.azure.com/";

let path = '/text/analytics/v2.1/keyPhrases';

let response_handler = function (response) {
    let body = '';
    response.on('data', function (d) {
        body += d;
    });
    response.on('end', function () {
        let body_ = JSON.parse(body);
        let body__ = JSON.stringify(body_, null, '  ');
        console.log(body__);
    });
    response.on('error', function (e) {
        console.log('Error: ' + e.message);
    });
};

let get_key_phrases = function (documents) {
    let body = JSON.stringify(documents);

    let request_params = {
        method: 'POST',
        hostname: (new URL(endpoint)).hostname,
        path: path,
        headers: {
            'Ocp-Apim-Subscription-Key': subscription_key,
        }
    };

    let req = https.request(request_params, response_handler);
    req.write(body);
    req.end();
}

let documents = {
    'documents': [
        { 'id': '1', 'language': 'en', 'text': 'The Ultimate Sustainable and Ethical Fashion Glossary.' },
        { 'id': '2', 'language': 'en', 'text': 'When you discover sustainable fashion, a whole new world of possibilities opens up before your very eyes. In the process, you also encounter a whole new lot of terminology you didn’t know before. It can be a bit confusing. Eco-fashion, green fashion, sustainable, ethical? What do they all mean? Are they the same? What are the differences? If you’re interested in living more sustainably, I’ve listed 20 essential terms that are used in the sustainable and ethical fashion world:' },
        { 'id': '3', 'language': 'en', 'text': 'Let’s start with the basics: in 1987, the UN defined sustainability as: "development that meets the needs of the present without compromising the ability of future generations to meet their own needs". In light of this definition, sustainable fashion refers to a more environmentally-friendly approach to designing, manufacturing and consuming clothes, making sure we cause little to no harm to our planet and don’t use up all its natural resources. Sustainable fashion also focuses on extending the life of clothes, using recycled materials and recycling in general.' }
    ]
};

get_key_phrases(documents);