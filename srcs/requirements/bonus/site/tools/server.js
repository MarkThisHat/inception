const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 7000;
const root = '/var/www/site';

// Ensure root exists and has index.html
if (!fs.existsSync(root)) {
  fs.mkdirSync(root, { recursive: true });
}
if (fs.readdirSync(root).length === 0) {
  fs.copyFileSync(path.join(__dirname, 'index.html'), path.join(root, 'index.html'));
}

http.createServer((req, res) => {
  // Strip optional `/site` prefix if behind reverse proxy
  let relativeUrl = req.url.replace(/^\/site/, '') || '/index.html';
  relativeUrl = decodeURIComponent(relativeUrl); // handle %20 etc.
  const safePath = path.normalize(relativeUrl).replace(/^(\.\.[/\\])+/, '');

  const filePath = path.join(root, safePath);

  fs.readFile(filePath, (err, content) => {
    if (err) {
      console.log(`[404] ${req.url}`);
      res.writeHead(404);
      res.end('404 Not Found');
    } else {
      console.log(`[200] ${req.url}`);
      res.writeHead(200);
      res.end(content);
    }
  });
}).listen(port, () => {
  console.log(`📦 Site served at http://localhost:${port}`);
});
