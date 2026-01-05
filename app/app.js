const express = require('express');
const os = require('os');

const app = express();

const PORT = process.env.PORT || 3000;
const NODE_NUMBER = process.env.NODE_NUMBER || "00";
const VERSION = process.env.APP_VERSION || "0.0";

const HOSTNAME = `${os.hostname()}-Node-${NODE_NUMBER}`;

app.get('/', (req, res) => {
  res.send(`
    <html>
      <head>
        <title>Node App</title>
      </head>
      <body style="text-align:center;font-family:Arial">
        <h1>${HOSTNAME}</h1>
        <h3>Version ${VERSION}</h3>
      </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`App running on port ${PORT}`);
});
