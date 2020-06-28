const fs = require('fs');
const got = require('got');
const jsdom = require("jsdom");
const { JSDOM } = jsdom;

let methods = {};

methods.web_scrape = async function (url) {
	let response; 
	try {
		response = await got(url);
	} catch {
		console.log(err);
		return [[], []];
	}
	
	const dom = new JSDOM(response.body);
	let title = dom.window.document.querySelector('title').textContent;
	// console.log("TITLE: " + title);

	let titlesArray = [];
	let titles = dom.window.document.querySelectorAll('h1');
  	titles.forEach(function(title){
  		titlesArray.push(title.textContent.replace(/\s+/g,' ').trim());
  	});

	let textsArray = [];
  	let texts = dom.window.document.querySelectorAll('p');
  	texts.forEach(function(text){
  		content = text.textContent;
  		if (content.split(" ").length > 10) {
  			textsArray.push(content);
  		}
  	});
  	textsArray.splice(3, textsArray.length - 6);

  	// console.log("\nBodies: \n---" + textsArray.join("\n---"));
  	// console.log("\nTitles: \n---" + titlesArray.join("\n---"));
  	// console.log("\nProcessed " + textsArray.length + " paragraphs for " + title);

  	const res = [title, titlesArray, textsArray];
  	return res;
}

methods.article_info = async function (url) {
	let response;
	try {
		response = await got(url);
	} catch {
		console.log(err);
		return;
	}

	const dom = new JSDOM(response.body);
	let title = dom.window.document.querySelector('title').textContent;
	let img = dom.window.document.querySelector('img[src^="http"]');
	let imgsrc = 'https://cdn1.iconfinder.com/data/icons/office-1/128/4-512.png';
	if (img != null) {
		imgsrc = img.getAttribute("src");
	}

	console.log(imgsrc);
	// let datetime = dom.window.document.querySelector('time').getAttribute("datetime");

  	const res = [title, imgsrc];
  	return res;
}

/* IGNORE-- handpicked articles instead of scraping
methods.scrape_nyt = async function (sectionURL) {
	let response;
	try {
		response = await got(url);
	} catch {
		console.log(err);
		return;
	}

	const dom = new JSDOM(response.body);
	let articles = dom.window.document.querySelectorAll('article');

	articles.forEach(function(article){
  		let link = article.getElementById("a");
  		console.log(link);
  	}); 
	
  	const res = [];
  	return res;
}*/

// const url= 'https://www.nytimes.com/2019/06/16/smarter-living/the-workplace-still-isnt-equal-for-women-heres-some-advice-to-navigate-it.html';
// methods.web_scrape(url).then(res => {
// 	console.log(res);
// })

// methods.article_info('https://www.wsj.com/articles/masks-could-help-stop-coronavirus-so-why-are-they-still-controversial-11593336601').then(res => {
// 	console.log(res);
// });


module.exports = methods;
