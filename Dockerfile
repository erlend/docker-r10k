FROM alpine:3.3
MAINTAINER Erlend Finvåg <erlend@spiri.no>

ENV GIT_DEPLOY_KEY=""
ENV GIT_REMOTE=""
ENV WEBHOOK_SECRET=""

# Install prereqiusites
RUN apk add --no-cache \
      ruby-unicorn ruby-json ruby-bundler ruby-io-console \
      git openssh-client su-exec

# Create non-root user
RUN adduser -D r10k

VOLUME /var/cache/r10k # r10k cache
VOLUME /etc/puppetlabs/code/environments # puppet environments

EXPOSE 8080

COPY . /app
WORKDIR /app
RUN bundle install --without=test

ENTRYPOINT ["./entrypoint.sh"]
