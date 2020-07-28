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

  	const res = [title, imgsrc];
  	return res;
}

module.exports = methods;
