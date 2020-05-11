server {
  server_name newyork.urbnv.com;
  access_log  /var/log/nginx/newyork.urbnv.access.log;
  error_log  /var/log/nginx/newyork.urbnv.error.log;
  location  / {
    root  /var/www/newyork.urbnv.com;
    index  index.html index.htm;
  }


    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/urbnv.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/urbnv.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot

ssl_dhparam /etc/ssl/certs/dhparam.pem;

     # Redirect non-https traffic to https
      if ($scheme != "https") {
        return 301 https://$host$request_uri;
      } # managed by Certbot



}
server {
    if ($host = newyork.urbnv.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  listen  80;
  server_name newyork.urbnv.com;
    return 404; # managed by Certbot


}
