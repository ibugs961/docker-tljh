FROM ubuntu:18.04

ENV HOME=/

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install systemd sudo python3.6 git curl -y

RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

RUN mkdir -p /etc/sudoers.d

RUN systemctl set-default multi-user.target

STOPSIGNAL SIGRTMIN+3

# Set up image to be useful out of the box for development & CI
ENV PATH=/opt/tljh/hub/bin:${PATH}

RUN curl https://raw.githubusercontent.com/jupyterhub/the-littlest-jupyterhub/master/bootstrap/bootstrap.py > bootstrap.py && \
    /usr/bin/python3.6 bootstrap.py --admin hubAdmin
    
EXPOSE 8000

WORKDIR $HOME

CMD /bin/bash
