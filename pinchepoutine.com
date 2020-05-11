server {
    root /var/www/pinchepoutine.com/wpwebsite;
    index  index.php index.html index.htm;
    server_name  pinchepoutine.com www.pinchepoutine.com;

    client_max_body_size 500M;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }
	
    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }	

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }	

    location ~ \.php$ {
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
         include fastcgi_params;
    }
location ~ ([^/]*)sitemap(.*).x(m|s)l$ {
rewrite ^/sitemap(-+([a-zA-Z0-9_-]+))?\.xml$ "/index.php?xml_sitemap=params=$2" last;
rewrite ^/sitemap(-+([a-zA-Z0-9_-]+))?\.xml\.gz$ "/index.php?xml_sitemap=params=$2;zip=true" last;
rewrite ^/sitemap(-+([a-zA-Z0-9_-]+))?\.html$ "/index.php?xml_sitemap=params=$2;html=true" last;
rewrite ^/sitemap(-+([a-zA-Z0-9_-]+))?\.html.gz$ "/index.php?xml_sitemap=params=$2;html=true;zip=true" last;
}



    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/pinchepoutine.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/pinchepoutine.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}
server {
    if ($host = www.pinchepoutine.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = pinchepoutine.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    server_name  pinchepoutine.com www.pinchepoutine.com;
    listen 80;
    return 404; # managed by Certbot




}
