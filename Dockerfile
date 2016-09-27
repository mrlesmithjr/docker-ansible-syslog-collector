FROM mrlesmithjr/alpine-ansible

MAINTAINER Larry Smith Jr. <mrlesmithjr@gmail.com>

ENV ENABLE_UDP="true" \
    REDIRECT_SYSLOG="true" \
    REDIRECT_SYSLOG_HOST="elk" \
    REDIRECT_SYSLOG_HOST_PORT="10514" \
    REDIRECT_SYSLOG_PROTOCOL="tcp" \
    UDP_PORT="514"

# Copy Ansible Related Files
COPY config/ansible/ /

# Run Ansible playbook
RUN ansible-playbook -i "localhost," -c local /rsyslog.yml && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# Copy Docker Entrypoint
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

COPY config/supervisord/*.ini /etc/supervisor.d/

# Expose Ports
EXPOSE 514/udp
