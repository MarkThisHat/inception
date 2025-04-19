const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 7000;
const root = '/var/www/site';
const urlPrefix = '/site'; // this is how it's routed in Nginx

if (!fs.existsSync(root)) fs.mkdirSync(root, { recursive: true });
if (fs.readdirSync(root).length === 0) {
  fs.copyFileSync(path.join(__dirname, 'index.html'), path.join(root, 'index.html'));
}

http.createServer((req, res) => {
  let reqPath = decodeURIComponent(req.url);
  if (reqPath === `${urlPrefix}/`) reqPath = `${urlPrefix}/index.html`;

  // Strip the prefix to map to actual disk path
  const localPath = reqPath.replace(urlPrefix, '');
  const safePath = path.normalize(localPath).replace(/^(\.\.[\/\\])+/, '');
  const fullPath = path.join(root, safePath);

  fs.stat(fullPath, (err, stats) => {
    if (err) {
      console.log(`[404] ${req.url}`);
      res.writeHead(404);
      return res.end('404 Not Found');
    }

    if (stats.isDirectory()) {
      fs.readdir(fullPath, (err, files) => {
        if (err) {
          res.writeHead(500);
          return res.end('500 Internal Server Error');
        }

        const links = files.map(file => {
          const slash = reqPath.endsWith('/') ? '' : '/';
          const linkHref = `${urlPrefix}${localPath}${slash}${file}`;
          return `<li><a href="${linkHref}">${file}</a></li>`;
        }).join('\n');

        const html = `
          <html>
            <head><title>Index of ${reqPath}</title></head>
            <body>
              <h1>Index of ${reqPath}</h1>
              <ul>${links}</ul>
            </body>
          </html>
        `;

        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(html);
      });
    } else {
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
  console.log(`📦 Site served at http://localhost:${port} (proxied to /site/)`);
});
