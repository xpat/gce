server {
  server_name  www.urbaninversion.com urbaninversion.com;
  access_log  /var/log/nginx/urbaninversion.access.log;
  error_log  /var/log/nginx/urbaninversion.error.log;
  location  / {
    root  /var/www/urbaninversion;
    index  index.html index.htm;
  }



    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/urbaninversion/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/urbaninversion/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}

server {
    if ($host = www.urbaninversion.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = urbaninversion.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  listen  80;
  server_name  www.urbaninversion.com urbaninversion.com;
    return 404; # managed by Certbot




}