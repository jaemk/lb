set -ex


if [[ "$1" = "renew" ]]; then
    ./certs.sh renew
fi

sudo cp 404.html /usr/share/nginx/html/404.html
sudo cp kom-ssl-config.conf /etc/nginx/snippets/kom-ssl-config.conf
sudo cp kom.conf /etc/nginx/sites-available/kom.conf
sudo ln -sf /etc/nginx/sites-available/kom.conf /etc/nginx/sites-enabled/kom.conf

sudo nginx -t
sudo systemctl restart nginx

./logs.sh
