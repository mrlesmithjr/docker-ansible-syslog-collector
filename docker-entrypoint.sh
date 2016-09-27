#!/bin/sh

ansible-playbook -i "localhost," -c local /docker-entrypoint.yml \
  --extra-vars "enable_udp=$ENABLE_UDP redirect_syslog=$REDIRECT_SYSLOG \
  redirect_syslog_host=$REDIRECT_SYSLOG_HOST \
  redirect_syslog_host_port=$REDIRECT_SYSLOG_HOST_PORT \
  redirect_syslog_protocol=$REDIRECT_SYSLOG_PROTOCOL \
  udp_port=$UDP_PORT"

exec supervisord -n
