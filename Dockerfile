FROM docker.elastic.co/beats/filebeat:5.2.2
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
