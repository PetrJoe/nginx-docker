FROM nginx:alpine

# Remove default NGINX website
RUN rm -rf /usr/share/nginx/html/*

# Copy custom configuration file
COPY default.conf /etc/nginx/conf.d/default.conf.template

# Copy website files
COPY public /usr/share/nginx/html

EXPOSE 80

# Install envsubst utility
RUN apk add --no-cache bash

# Create a script to substitute environment variables and start nginx
RUN echo '#!/bin/bash\n\
envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf\n\
nginx -g "daemon off;"' > /docker-entrypoint.sh && \
chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
