const http = require('http');
const fs = require('fs');
const path = require('path');
const port = 7000;
const root = '/var/www/site';

if (!fs.existsSync(root)) fs.mkdirSync(root, { recursive: true });
if (fs.readdirSync(root).length === 0) {
  fs.copyFileSync(path.join(__dirname, 'index.html'), path.join(root, 'index.html'));
}

http.createServer((req, res) => {
  let reqPath = decodeURIComponent(req.url);
  if (reqPath === '/') reqPath = '/index.html';

  // Normalize to prevent path traversal
  const safePath = path.normalize(reqPath).replace(/^(\.\.[\/\\])+/, '');
  const fullPath = path.join(root, safePath);

  fs.readFile(fullPath, (err, content) => {
    if (err) {
      console.log(`[404] ${reqPath}`);
      res.writeHead(404);
      res.end('404 Not Found');
    } else {
      console.log(`[200] ${reqPath}`);
      res.writeHead(200);
      res.end(content);
    }
  });
}).listen(port, () => {
  console.log(`📦 Site served at http://localhost:${port}`);
});
