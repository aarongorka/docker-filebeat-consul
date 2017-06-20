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

curl "${NOMAD_IP_http}:8500/v1/kv/jobs/${NOMAD_META_name}/${NOMAD_META_version}/filebeat" | jq -r '.[] | .Value' | base64 -d | tee /etc/filebeat/filebeat.yml
filebeat -e -c /etc/filebeat/filebeat.yml
