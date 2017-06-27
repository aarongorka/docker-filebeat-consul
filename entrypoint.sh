#!/usr/bin/env bash

# Failsafe settings
LC_ALL=C
PATH='/sbin:/usr/sbin:/bin:/usr/bin'
set -o noclobber
set -o errexit
set -o nounset
set -o pipefail
shopt -s nullglob
unalias -a

# there's multiple NOMAD_IP_x variables so just grab the value of one
IP="$(env | grep NOMAD_IP | head -n 1 | cut -f 2 -d '=')"

set +o errexit
OUTPUT="$(curl -q "${IP}:8500/v1/kv/jobs/${NOMAD_META_name}/${NOMAD_META_version}/filebeat" | jq -r '.[] | .Value' | base64 -d)"
set -o errexit

if filebeat -configtest -e -c "<(${OUTPUT})"; then
  echo "${OUTPUT}" | tee ./filebeat.yml
fi

./filebeat -e -c ./filebeat.yml
