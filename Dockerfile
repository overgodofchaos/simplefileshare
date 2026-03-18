FROM nginx:alpine

RUN apk update && apk add --no-cache \
    git openssh-client busybox \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /data/files

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY git-sync.sh /usr/local/bin/git-sync.sh
RUN chmod +x /usr/local/bin/git-sync.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]