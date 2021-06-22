set -ex


if [[ "$1" = "renew" ]]; then
    ./certs/make-cert.sh renew
fi

sudo cp nginx/404.html /usr/share/nginx/html/404.html
sudo cp nginx/kom-ssl-config.conf /etc/nginx/snippets/kom-ssl-config.conf
sudo cp nginx/kom.conf /etc/nginx/sites-available/kom.conf
sudo ln -sf /etc/nginx/sites-available/kom.conf /etc/nginx/sites-enabled/kom.conf

sudo nginx -t
sudo systemctl restart nginx

sudo cp systemd/upaste.service /etc/systemd/system/upaste.service
sudo chmod 644 /etc/systemd/system/upaste.service
sudo systemctl daemon-reload
sudo systemctl enable upaste
sudo systemctl restart upaste

./logs.sh
