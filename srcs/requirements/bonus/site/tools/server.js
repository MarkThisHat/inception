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

  const safePath = path.normalize(reqPath).replace(/^(\.\.[\/\\])+/, '');
  const fullPath = path.join(root, safePath);

  fs.stat(fullPath, (err, stats) => {
    if (err) {
      console.log(`[404] ${reqPath}`);
      res.writeHead(404);
      return res.end('404 Not Found');
    }

    if (stats.isDirectory()) {
      // Directory listing
      fs.readdir(fullPath, (err, files) => {
        if (err) {
          res.writeHead(500);
          return res.end('500 Internal Server Error');
        }

        const links = files.map(file => {
          const slash = reqPath.endsWith('/') ? '' : '/';
          return `<li><a href="${reqPath + slash + file}">${file}</a></li>`;
        }).join('\n');

        const html = `
          <html><head><title>Index of ${reqPath}</title></head>
          <body><h1>Index of ${reqPath}</h1><ul>${links}</ul></body></html>
        `;

        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(html);
      });
    } else {
      // Serve file
      fs.readFile(fullPath, (err, content) => {
        if (err) {
          res.writeHead(404);
          res.end('404 Not Found');
        } else {
          res.writeHead(200);
          res.end(content);
        }
      });
    }
  });
}).listen(port, () => {
  console.log(`📦 Site served at http://localhost:${port}`);
});
