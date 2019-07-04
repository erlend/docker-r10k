FROM ruby:alpine
MAINTAINER Erlend Finvåg <erlend@spiri.no>

ARG R10K_VERSION="~> 2.4"
ENV GIT_DEPLOY_KEY=""
ENV GIT_REMOTE=""
ENV WEBHOOK_SECRET=""

# Install prereqiusites
RUN apk add build-base git openssh-client su-exec && \
    gem install -N unicorn r10k:"$R10K_VERSION" && \
    apk del build-base && \
    rm /var/cache/apk/*

# Create non-root user
RUN adduser -D r10k

# Disable ssh host key check as there is no shell to accept it in
RUN echo "Host *" >> /etc/ssh/ssh_config && \
    echo "  StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Install app
COPY . /app
WORKDIR /app
RUN bundle install --without=test

EXPOSE 8080

VOLUME /var/cache/r10k
VOLUME /etc/puppetlabs/code/environments

ENTRYPOINT ["./entrypoint.sh"]
