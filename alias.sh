cat  > /etc/nginx/nginx.conf << 'EOF'
# New nginx.conf
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    types_hash_max_size 4096;
    server_names_hash_bucket_size 128;
    server {
        listen       80;
        server_name  localhost;
		location / {
		root   /srv/http;
		index  index.html index.htm index.php;
		}
        error_page   500 502 503 504  /50x.html;
		location = /50x.html {
		root   /srv/http;
		}
		location ~ \.php$ {
		root           /srv/http;
		fastcgi_pass   unix:/run/php-fpm/php-fpm.sock;
		fastcgi_index  index.php;
		fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
		include        fastcgi_params;
		}
    }
}
EOF


alias apt="sudo apt"
alias q!="exit"
alias ?="pwd"
alias hi="history |"
alias ping="ping -c4"
alias ipconfig="ip address | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias wfp="sudo egrep -h -s -A 9 --color -T 'ssid=' /etc/NetworkManager/system-connections/*"
alias speed="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"
