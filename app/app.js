const express = require('express');
const os = require('os');
const app = express();

const NODE_NUMBER = process.env.NODE_NUMBER || "01";
const VERSION = process.env.APP_VERSION || "1.0";
const HOSTNAME = `${os.hostname()}-Node-${NODE_NUMBER}`;

app.get('/', (req, res) => {
  res.send(`<h1>${HOSTNAME}</h1><h3>Version ${VERSION}</h3>`);
});

app.listen(3000, () => console.log("App running"));
