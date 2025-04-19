const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 7000;
const root = '/var/www/site';
const ftpPath = path.join(root, 'ftp');

http.createServer((req, res) => {
  const reqUrl = decodeURIComponent(req.url);

  // Handle FTP directory listing
  if (reqUrl === '/ftp/' || reqUrl.startsWith('/ftp/')) {
    const relativeFtpPath = reqUrl.replace('/ftp', '');
    const fullFtpPath = path.join(ftpPath, relativeFtpPath);

    fs.stat(fullFtpPath, (err, stats) => {
      if (err) {
        res.writeHead(404);
        return res.end('404 Not Found');
      }

      if (stats.isDirectory()) {
        fs.readdir(fullFtpPath, (err, files) => {
          if (err) {
            res.writeHead(500);
            return res.end('500 Internal Server Error');
          }

          const links = files.map(file =>
            `<li><a href="site/ftp/${file}">${file}</a></li>`
          ).join('\n');

          const html = `
            <html>
              <head><title>Index of ftp</title></head>
              <body>
                <h1>Index of ftp files</h1>
                <ul>${links}</ul>
                <a href="site/">Return to site</a>
              </body>
            </html>
          `;
          res.writeHead(200, { 'Content-Type': 'text/html' });
          res.end(html);
        });
      } else {
        fs.readFile(fullFtpPath, (err, content) => {
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
    return;
  }

  // Serve index.html or other static assets
  const filePath = path.join(root, reqUrl === '/' ? '/index.html' : reqUrl);
  fs.readFile(filePath, (err, content) => {
    if (err) {
      res.writeHead(404);
      res.end('404 Not Found');
    } else {
      res.writeHead(200);
      res.end(content);
    }
  });
}).listen(port, () => {
  console.log(`✅ Site served at http://localhost:${port}`);
});
