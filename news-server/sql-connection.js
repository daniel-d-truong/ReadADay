const { Connection, Request } = require("tedious");

//
//  Select Queries
//
exports.selectArticlesAll = () => runSelectQuery(`SELECT * FROM Articles`);
exports.selectArticlesForUser = (username) => runSelectQuery(`SELECT Articles.* FROM ReadArticles JOIN Articles ON Articles.ID = ReadArticles.ArticleID WHERE Username='${username}' ORDER BY DateRead DESC`);
exports.selectReadArticlesTimesForUser = (username) => runSelectQuery(`SELECT DateRead from ReadArticles ORDER BY DateRead DESC`);

//
//  Insert Queries
//
exports.insertArticlesEntry = (title, articleURL, imageURL, date, category) => runInsertQuery(`INSERT INTO Articles(Title, ArticleURL, ImageURL, ArticleDate, Category) VALUES ('${title}', '${articleURL}', '${imageURL}', ${date}, '${category}')`);
exports.insertReadArticlesEntry = (user, article, date) => runInsertQuery(`INSERT INTO ReadArticles(ArticleID, DateRead, Username) VALUES (${article}, ${date}, '${user}')`);

//
//  Database Code
//
const config = {
	authentication: {
		options: {
			userName: "ringale", // update me
			password: "intern4good!" // update me
		},
		type: "default"
	},
	server: "ms-hackathon-server.database.windows.net", // update me
	options: {
		database: "ms-hackathon-db", //update me
		encrypt: true
	}
};

const runSelectQuery = (query) => {
	return new Promise((resolve, reject) => {
		// Attempt to connect and execute queries if connection goes through
		const connection = new Connection(config);
		connection.on("connect", err => {
			if (err) {
				reject(err.message);
				return;
			}

			let arr = [];
			const request = new Request(
				query,
				(err, rowCount) => {
					if (err) {
						reject(err);
					} else {
						resolve(arr);
					}

					connection.close();
				}
			);

			request.on("row", columns => {
				let row = {};
				columns.forEach(column => {
					row[column.metadata.colName] = column.value;
				});
				arr.push(row);
			});


			connection.execSql(request);
		});
	});
}

const runInsertQuery = (query) => {
	return new Promise((resolve, reject) => {
		// Attempt to connect and execute queries if connection goes through
		const connection = new Connection(config);
		connection.on("connect", err => {
			if (err) {
				reject(err.message);
				return;
			}

			const request = new Request(
				query,
				(err) => {
					if (err) {
						reject(err.message);
					} else {
						resolve();
					}

					connection.close();
				}
			);

			connection.execSql(request);
		});
	});
}
