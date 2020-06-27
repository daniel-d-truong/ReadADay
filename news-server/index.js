import express from "express";

const app = express();
const serverPort = 8000;

app.get("/", (request, response) => {
    response.send("Hello, world!");
});

app.listen(serverPort, () => console.log(`Server started on port ${serverPort}!`));
