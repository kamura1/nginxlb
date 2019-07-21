FROM alpine:3.8

ENV PROXY_HOST=5
ENV PROXY_PATH=5
ENV NGINX_PORT=80

COPY ./data/* /var/opt/

RUN mkdir -p /run/nginx \
	&& apk --no-cache add --update nginx \
	&& apk --no-cache add --update bash \
	&& cd /var/opt/ \
	&& mv nginx_config.conf /etc/nginx/conf.d/default.conf \
	&& chmod +x  entrypoint.sh

ENTRYPOINT ["/var/opt/entrypoint.sh"]
