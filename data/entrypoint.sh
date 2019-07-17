#!/bin/sh

for x in $PROXY_PATH $PROXY_HOST $NGINX_PORT; do
    if `echo $x | egrep -q '^[0-9]+$'`; then
        echo "$x is a number"
    else
        echo "environment variables PROXY_PATH, PROXY_HOST and NGINX_PORT must be numeric" >&2
        exit 1
    fi
done
if [ $PROXY_HOST -ne $PROXY_PATH ]
then
    echo "environment variable PROXY_HOST must be equal to PROXY_PATH" >&2
    exit 1
fi

host=1
path=1
nginx_config_location="/etc/nginx/conf.d/default.conf"

sed -i '$d' /etc/nginx/conf.d/default.conf
sed -i "s/80/$NGINX_PORT/g" /etc/nginx/conf.d/default.conf
while [ $host -le $PROXY_HOST ]
do
    vh_name=PROXY_HOST_$host
    cat >> $nginx_config_location << EOF
        location ~ /PROXY_PATH_$path(|/)$ {
                proxy_pass  http://PROXY_HOST_$host;
        }
EOF

    host=`expr $host + 1`
    path=`expr $path + 1`
    echo "127.0.0.1   $vh_name" >> /etc/hosts

done
echo "}" >> $nginx_config_location
nginx -g "daemon off;"