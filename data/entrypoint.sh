#!/bin/bash

nginx_config_location="/etc/nginx/conf.d/default.conf"

sed -i '$d' $nginx_config_location

proxy_hosts=( `printenv | grep PROXY_HOST_ | sort -n | awk -F "=" '{print $2}'` )
proxy_locations=( `printenv | grep PROXY_PATH_ | sort -n | awk -F "=" '{print $2}'` )


if [ -z $NGINX_PORT ] ; then
  echo "Set NGINX PORT to default port 80"
elif `echo $NGINX_PORT | egrep -q '^[0-9]+$'`; then
    echo "NGINX PORT = $NGINX_PORT"
else
    echo "environment variables NGINX_PORT must be numeric" >&2
    exit 1
fi

sed -i "s/{NGINX_PORT}/$NGINX_PORT/g" $nginx_config_location

if [ ${#proxy_hosts[@]} -ne ${#proxy_locations[@]} ]
then
    echo "environment variable PROXY_HOST must be equal to PROXY_PATH" >&2
    exit 1
fi



i=0

while [ $i -lt "${#proxy_hosts[@]}" ]
do

cat >> $nginx_config_location << EOF
          location ~ /${proxy_locations[$i]}(|/)$ {
                  proxy_pass  http://${proxy_hosts[$i]};
          }
EOF
  echo "127.0.0.1   ${proxy_hosts[$i]}" >> /etc/hosts

  i=`expr $i + 1`

done

echo "}" >> $nginx_config_location

cat $nginx_config_location  >&2

nginx -g "daemon off;"
