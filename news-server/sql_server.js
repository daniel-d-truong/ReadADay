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

const connection = new Connection(config);
connection.on('debug', function (err) { console.log('debug:', err); });

// Attempt to connect and execute queries if connection goes through
connection.on("connect", err => {
	if (err) {
		console.error(err.message);
	} else {
		submitReadEntry("joe", 11, 600);
		queryDBForUserArticles("joe").then(out => {
			console.log(out);
		}).catch(err => {
			console.log(err);
		});
	}
});

function queryDBForUserArticles(user) {
	return new Promise(function (resolve, reject) {
		console.log("Getting User Information...");

		let obj = [];
		const request = new Request(
			"".concat(`SELECT * FROM ReadArticles WHERE Username='`, user, `'`),
			(err, rowCount) => {
				if (err) {
					reject(err);
				} else {
					resolve(obj);
					console.log(`${rowCount} row(s) returned`);
				}
			}
		);

		request.on("row", columns => {
			let entry = {};
			columns.forEach(column => {
				entry[column.metadata.colName] = column.value;
			});
		});

		connection.execSql(request);
	});
}

function submitReadEntry(user, article, date) {
	console.log("Putting a Read Entry...");

	const request = new Request(
		"".concat(`INSERT INTO ReadArticles(ArticleID, DateRead, Username) VALUES (`, article, `, `, date, `' `, user, `)`),
		(err, rowCount) => {
			if (err) {
				console.error(err.message);
			} else {
				console.log(`${rowCount} row(s) returned`);
			}
		}
	);

	connection.execSql(request);
}

