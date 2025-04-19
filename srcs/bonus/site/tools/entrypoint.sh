#!/bin/bash

mkdir -p /var/www/site/files

file_list=""
for f in /var/www/site/*; do
    [ -f "$f" ] || continue
    fname=$(basename "$f")
    file_list="${file_list}<li><a href=\"/site/files/$fname\">$fname</a></li>\n"
done

sed "s|{{FILES}}|$file_list|" /var/www/site/template.html > /var/www/site/files/index.html

/env/bin/gunicorn -b 0.0.0.0:5000 app:app


