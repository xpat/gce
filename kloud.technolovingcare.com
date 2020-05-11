server { 
  server_name kloud.technolovingcare.com;
  access_log  /var/log/nginx/kloud.technolovingcare.access.log;
  error_log  /var/log/nginx/kloud.technolovingcare.error.log;
  location  / {
    root /var/www/kloud.technolovingcare.com;
        index index.html index.htm;
}
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/technolovingcare.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/technolovingcare.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot

ssl_dhparam /etc/ssl/certs/dhparam.pem;

    # Redirect non-https traffic to https
      if ($scheme != "https") {
      return 301 https://$host$request_uri;
      } # managed by Certbot

}
server {
    if ($host = kloud.technolovingcare.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  listen  80; 
  server_name kloud.technolovingcare.com;
    return 404; # managed by Certbot


}