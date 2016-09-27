REPO INFO
=========
Builds a purpose built UDP rsyslog collector.. This is useful for spinning up
as a front-end container to redirect capture incoming syslog messages to your
back-end logging environment. Allows for a scaling syslog collector. TCP is not
being configured at this time because we can load-balance those connections.

Use-Cases
---------
Spin up across your environment to front-end syslog messages destined for UDP
ports which cannot be load-balanced. For example, HAProxy cannot load-balance
UDP so we can spin up many of these collectors and configure the `REDIRECT_SYSLOG`
variables to your load-balanced TCP syslog collectors (ELK).

* Note - If you adjust the `UDP_PORT` ensure that you also expose the new port.

`Dockerfile`
```
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
```

License
-------

BSD

Author Information
------------------

Larry Smith Jr.
- [@mrlesmithjr]
- [everythingshouldbevirtual.com]
- [mrlesmithjr@gmail.com]


[Docker]: <https://www.docker.com>
[Ansible]: <https://www.ansible.com/>
[@mrlesmithjr]: <https://twitter.com/mrlesmithjr>
[everythingshouldbevirtual.com]: <http://everythingshouldbevirtual.com>
[mrlesmithjr@gmail.com]: <mailto:mrlesmithjr@gmail.com>
