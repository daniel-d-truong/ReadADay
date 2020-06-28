const { Connection, Request } = require("tedious");

// Create connection to database
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

function queryDBForUserArticles(user) {
	return new Promise((resolve, reject) => {
		// Attempt to connect and execute queries if connection goes through
		const connection = new Connection(config);
		connection.on("connect", err => {
			if (err) {
				reject(err.message);
				return;
			}

			console.log("Getting User Information...");

			let arr = [];
			const request = new Request(
				`SELECT * FROM ReadArticles WHERE Username='${user}'`,
				(err, rowCount) => {
					if (err) {
						reject(err);
					} else {
						console.log(`${rowCount} row(s) returned`);
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

function submitReadEntry(user, article, date) {
	return new Promise((resolve, reject) => {
		// Attempt to connect and execute queries if connection goes through
		const connection = new Connection(config);
		connection.on("connect", err => {
			if (err) {
				reject(err.message);
				return;
			}

			console.log("Getting User Information...");

			const request = new Request(
				`INSERT INTO ReadArticles(ArticleID, DateRead, Username) VALUES (${article}, ${date}, '${user}')`,
				(err, rowCount) => {
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


// submitReadEntry("joe", 11, 600).then(out => {
// 	console.log("Success!");
// }).catch(err => {
// 	console.log(err);
// });

// queryDBForUserArticles("joe").then(out => {
// 	console.log(out);
// }).catch(err => {
// 	console.log(err);
// });