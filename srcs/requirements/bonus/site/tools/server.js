const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 7000;
const root = '/var/www/site';
const ftpRoot = '/var/www/site/ftp';

// Create /var/www/site if not exists and copy files
if (!fs.existsSync(root)) {
  fs.mkdirSync(root, { recursive: true });
}
if (fs.readdirSync(root).length === 0) {
  fs.copyFileSync(path.join(__dirname, 'index.html'), path.join(root, 'index.html'));
}

http.createServer((req, res) => {
  if (req.url.startsWith('/ftp/')) {
    // Handle FTP listing
    const dirPath = path.join(ftpRoot, req.url.replace('/ftp/', '') || '');
    fs.readdir(dirPath, (err, files) => {
      if (err) {
        res.writeHead(404);
        res.end('404 Not Found');
        return;
      }

      // Generate list of files with correct /site/ftp/ paths
      let fileLinks = files.map(file => {
        const filePath = `/site/ftp/${file}`;
        return `<li><a href="${filePath}">${file}</a></li>`;
      }).join('');

      // Add "Return to /site/" link at the bottom
      fileLinks += '<li><a href="/site/">Return to Site</a></li>';

      res.writeHead(200, { 'Content-Type': 'text/html' });
      res.end(`<ul>${fileLinks}</ul>`);
    });
  } else {
    // Serve the main site
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
