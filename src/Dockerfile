FROM alpine
MAINTAINER Ian Bytchek

COPY . /docker
RUN /docker/script/build.sh
EXPOSE 80 443
VOLUME /etc/haproxy

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]