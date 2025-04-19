from flask import Flask, render_template_string
import os

template = """
<!DOCTYPE html>
<html>
<head><title>FTP File Listing</title></head>
<body>
<h1>Shared Files</h1>
<ul>
    {% for file in files %}
    <li><a href="/site/files/{{ file }}">{{ file }}</a></li>
    {% endfor %}
</ul>
<a href="/site">← Back to home</a>
</body>
</html>
"""

ftp_dir = "/var/ftp"
files = [f for f in os.listdir(ftp_dir) if os.path.isfile(os.path.join(ftp_dir, f))]

html = render_template_string(template, files=files)

with open("/var/www/site/ftp/index.html", "w") as f:
    f.write(html)
