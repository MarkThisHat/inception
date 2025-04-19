#!/bin/bash

ftp_dir="/var/www/wordpress/ftp"
mkdir -p "$ftp_dir"

/env/bin/gunicorn -b 0.0.0.0:5000 app:app
