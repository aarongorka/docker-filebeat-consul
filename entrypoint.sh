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

curl "${IP}:8500/v1/kv/jobs/${NOMAD_META_name}/${NOMAD_META_version}/filebeat" | jq -r '.[] | .Value' | base64 -d | tee ./filebeat.yml

filebeat -e -c ./filebeat.yml
