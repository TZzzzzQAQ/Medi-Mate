FROM nginx:alpine

COPY /dist /usr/share/nginx/html

COPY /ca_bundle.crt /etc/ssl/certs
COPY /certificate.crt /etc/ssl/certs
COPY /private.key /etc/ssl/private

COPY nginx.conf /etc/nginx/nginx.conf
