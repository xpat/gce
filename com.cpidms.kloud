server {
    listen 80;
    server_name kloud.cpidms.com;
  access_log  /var/log/nginx/kloud.cpidms.access.log;
  error_log  /var/log/nginx/kloud.cpidms.error.log;
  location  / {
 root /var/www/kloud.cpidms.com;
           index index.html index.htm;
}
    

listen 443 ssl http2; # managed by Certbot
ssl_certificate /etc/letsencrypt/live/cpidms.com/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/cpidms.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot

ssl_dhparam /etc/ssl/certs/dhparam.pem;

   # Redirect non-https traffic to https
if ($scheme != "https") {
        return 301 https://$host$request_uri;
      } # managed by Certbot
}

