const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 7000;
const root = '/var/www/site';

// Create /var/www/site if not exists and copy files
if (!fs.existsSync(root)) {
  fs.mkdirSync(root, { recursive: true });
}
if (fs.readdirSync(root).length === 0) {
  fs.copyFileSync(path.join(__dirname, 'index.html'), path.join(root, 'index.html'));
}

http.createServer((req, res) => {
  if (req.url.startsWith('/ftp/')) {
    const filePath = path.join('/var/www/site', req.url);
    fs.readFile(filePath, (err, content) => {
      if (err) {
        res.writeHead(404);
        res.end('404 Not Found');
      } else {
        res.writeHead(200);
        res.end(content);
      }
    });
  } else {
    const filePath = path.join(root, req.url === '/' ? '/index.html' : req.url);
    fs.readFile(filePath, (err, content) => {
      if (err) {
        res.writeHead(404);
        res.end('404 Not Found');
      } else {
        res.writeHead(200);
        res.end(content);
      }
    });
  }
}).listen(port, () => {
  console.log(`Site served at http://localhost:${port}`);
});

