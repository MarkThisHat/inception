#!/bin/bash

mkdir -p /var/ftp /var/www/site/files

cp /var/www/site/index.html /var/www/site/index.html

file_list=""
for f in /var/ftp/*; do
    [ -f "$f" ] || continue
    fname=$(basename "$f")
    file_list="${file_list}<li><a href=\"/site/files/$fname\">$fname</a></li>\n"
done

sed "s|{{FILES}}|$file_list|" /var/www/site/template.html > /var/www/site/files/index.html

/env/bin/gunicorn -b 127.0.0.1:5000 app:app &

nginx -g "daemon off;"


