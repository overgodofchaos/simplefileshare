FROM nginx:alpine

RUN apk update && apk add --no-cache \
    git openssh-client busybox-cron \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /files/repo

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY git-pull.sh /usr/local/bin/git-pull.sh
RUN chmod +x /usr/local/bin/git-pull.sh

RUN echo "*/15 * * * * /usr/local/bin/git-pull.sh >> /var/log/git-pull.log 2>&1" > /etc/crontabs/root

COPY private-key /root/.ssh/krivate-key
RUN chmod 600 /root/.ssh/private-key

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]