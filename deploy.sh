set -e

RENEW=false
LB=false
TAIL=false
ALL=false
ALL_SVCS=false
SVC=

function die_usage {
  echo "Usage: $(basename $0) [-hnapr] [-s service]"
  echo ""
  echo "Deploy stuff"
  echo ""
  echo "Options:"
  echo "  -h           Show this beautiful message"
  echo "  -r           Run cert renewal script"
  echo "  -n           Deploy the nginx configs and restart nginx"
  echo "  -a           Deploy _everything_"
  echo "  -p           Deploy all services"
  echo "  -f           Tail nginx logs after running"
  echo "  -s SERVICE   Deploy a specific service"
  exit 1
}

while getopts "hrnapfs:" opt; do
  case $opt in
    h) die_usage ;;
    r) RENEW=true ;;
    n) LB=true ;;
    f) TAIL=true ;;
    a) ALL=true ;;
    p) ALL_SVCS=true ;;
    s) SVC="$OPTARG" ;;
    \? ) die_usage
      ;;
  esac
done

echo "ARGS:"
echo "  RENEW=$RENEW, LB=$LB"
echo "  ALL=$ALL, ALL_SVCS=$ALL_SVCS"
echo "  SVC=$SVC"
echo ""


if $RENEW; then
    echo "*** renewing certs..."
    set -x
    ./certs/make-all.sh renew
    set +x
fi

if $ALL || $LB; then
    echo "*** deploying nginx..."
    set -x
    sudo cp nginx/404.html /usr/share/nginx/html/404.html
    sudo cp nginx/kom-ssl-config.conf /etc/nginx/snippets/kom-ssl-config.conf
    sudo cp nginx/kom-org-ssl-config.conf /etc/nginx/snippets/kom-org-ssl-config.conf
    sudo cp nginx/kom-dev-ssl-config.conf /etc/nginx/snippets/kom-dev-ssl-config.conf
    sudo cp nginx/slackat-ssl-config.conf /etc/nginx/snippets/slackat-ssl-config.conf
    sudo cp nginx/soundlog-ssl-config.conf /etc/nginx/snippets/soundlog-ssl-config.conf
    sudo cp nginx/feelsgut-ssl-config.conf /etc/nginx/snippets/feelsgut-ssl-config.conf
    sudo cp nginx/didpoop-ssl-config.conf /etc/nginx/snippets/didpoop-ssl-config.conf
    sudo cp nginx/kom.conf /etc/nginx/sites-available/kom.conf
    sudo ln -sf /etc/nginx/sites-available/kom.conf /etc/nginx/sites-enabled/kom.conf

    sudo nginx -t
    sudo systemctl restart nginx
    set +x
fi

function deploy_service {
    echo "*** deploying $1..."
    set -x
    sudo cp systemd/$1.service /etc/systemd/system/$1.service
    sudo chmod 644 /etc/systemd/system/$1.service
    sudo systemctl daemon-reload
    sudo systemctl enable $1
    sudo systemctl restart $1
    set +x
}

if $ALL || $ALL_SVCS || [[ "$SVC" = "transfer" ]]; then
    deploy_service "transfer"
fi

if $ALL || $ALL_SVCS || [[ "$SVC" = "upaste" ]]; then
    deploy_service "upaste"
fi

if $ALL || $ALL_SVCS || [[ "$SVC" = "badge" ]]; then
    deploy_service "badge"
fi

if $ALL || $ALL_SVCS || [[ "$SVC" = "homepage" ]]; then
    deploy_service "homepage"
fi

if $ALL || $ALL_SVCS || [[ "$SVC" = "slackat" ]]; then
    deploy_service "slackat"
fi

if $ALL || $ALL_SVCS || [[ "$SVC" = "soundlog" ]]; then
    deploy_service "soundlog"
fi

if $ALL || $ALL_SVCS || [[ "$SVC" = "ritide" ]]; then
    deploy_service "ritide"
fi

if $ALL || $ALL_SVCS || [[ "$SVC" = "outside" ]]; then
    deploy_service "outside"
fi

if $TAIL; then
    ./logs.sh
fi
