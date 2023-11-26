FROM nginx:1.25.3-alpine

RUN mkdir -p /etc/nginx/logs

RUN rm /etc/nginx/conf.d/default.conf

ADD ssl/nginx-selfsigned.crt /etc/ssl/certs/
ADD ssl/app-certificate.crt /etc/ssl/certs/
ADD ssl/certsdhparam.pem /etc/ssl/certs/
ADD ssl/nginx-selfsigned.key /etc/ssl/private/
ADD ssl/app-certificate-private-key.pem /etc/ssl/private/

ADD nginx.conf /etc/nginx/conf.d/default.conf
ADD snippets /etc/nginx/snippets