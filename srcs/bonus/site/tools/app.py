from flask import Flask, render_template_string
import os

app = Flask(__name__)

template = """
<!DOCTYPE html>
<html>
<head><title>FTP File Listing</title></head>
<body>
<h1>Shared Files</h1>
<ul>
    {% for file in files %}
    <li><a href="/site/{{ file }}">{{ file }}</a></li>
    {% endfor %}
</ul>
<a href="/">← Back to home</a>
</body>
</html>
"""

@app.route("/")
def index():
    ftp_dir = "/var/www/wordpress/ftp"
    files = [f for f in os.listdir(ftp_dir) if os.path.isfile(os.path.join(ftp_dir, f))]
    return render_template_string(template, files=files)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
