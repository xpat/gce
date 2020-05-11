upstream techno {
server 127.0.0.1:8069;
}
server {
listen 80;
  server_name technolovingcare.com;
  access_log  /var/log/nginx/technolovingcare.access.log;
  error_log  /var/log/nginx/technolovingcare.error.log;
  location  / {
#    root  /var/www/technolovingcare;
#    index  index.html index.htm;
#  proxy_pass          http://localhost:4200;
#  proxy_read_timeout  90;
#  proxy_redirect      http://localhost:4200 https://technolovingcare.com;
 }


    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/technolovingcare.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/technolovingcare.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot

#ssl_dhparam /etc/certs/dhparam.pem;
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
    # Redirect non-https traffic to https
     if ($scheme != "https") {
         return 301 https://$host$request_uri;
     } # managed by Certbot



} 
server {
    if ($host = www.technolovingcare.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = technolovingcare.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


#  listen  80;
#  server_name www.technolovingcare.com technolovingcare.com;
#    return 404; # managed by Certbot




}
