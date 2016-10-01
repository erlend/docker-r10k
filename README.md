R10k GitLab
===========

Puppet deployments with GitLab's webhooks and R10k

## Usage

Set the following environment variables:

`WEBHOOK_SECRET` | The secret specified when creating the webhook in GitLab
`GIT_REMOTE`     | Path to your git repository
`GIT_DEPLOY_KEY` | SSH private key for deployment

You will also need to point your loadbalancer to or forward port 8080.

### Example 1 (with deploy key variable)

```
$ docker run -p 8080:8080 \
             -e WEBHOOK_SECRET=topsecret \
             -e GIT_REMOTE=git@github.com:erlend/docker-r10k.git \
             -e GIT_DEPLOY_KEY="`cat ~/.ssh/id_rsa`" \
             erlend/r10k
```

### Example 2 (with deploy key as file)

```
$ docker run -p 8080:8080 \
             -e WEBHOOK_SECRET=topsecret \
             -e GIT_REMOTE=git@github.com:erlend/docker-r10k.git \
             -v ~/.ssh/id_rsa:/home/r10k/.ssh/id_rsa:ro \
             erlend/r10k
```

