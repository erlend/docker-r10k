#!/bin/sh

run-parts --exit-on-error entrypoint.d

if [ -z $1 ]; then
  set -- su-exec r10k unicorn -o :: -E production
fi

exec $@
