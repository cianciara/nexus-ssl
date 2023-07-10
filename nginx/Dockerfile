# NGINX reverse proxy
 
# Base docker image
FROM nginx:alpine

RUN mkdir -p /etc/nginx/certs

COPY nginx-key.pem /etc/nginx/certs/nginx-key.pem

COPY nginx-cert.pem /etc/nginx/certs/nginx-cert.pem

COPY nginx.conf /etc/nginx/nginx.conf
