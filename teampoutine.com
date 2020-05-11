upstream teampoutinecom {
    server 127.0.0.1:8069;
}
server {
    root  /var/www/teampoutine.com;
    index index.html;
    server_name teampoutine.com www.teampoutine.com;
    access_log  /var/log/nginx/teampoutine.com.access.log;
    error_log  /var/log/nginx/teampoutine.com.error.log;

    #listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/teampoutine.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/teampoutine.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


    # proxy buffers
    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    ## default location ##
    location / {
        proxy_pass  http://teampoutinecom;
        # force timeouts if the backend dies
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;

        # set headers
        proxy_set_header    Host            $host;
        proxy_set_header    X-Real-IP       $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto https;
    }

    # cache some static data in memory for 60 mins
    location ~* /web/static/ {
        proxy_cache_valid 200 60m;
        proxy_buffering on;
        expires 864000;
        proxy_pass http://teampoutinecom;
    }



}

server {
    if ($host = teampoutine.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = www.teampoutine.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    server_name teampoutine.com www.teampoutine.com;
    listen 80;
    listen [::]:80;
    return 404; # managed by Certbot
}

