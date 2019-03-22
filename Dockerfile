FROM ubuntu:18.04

ENV HOME=/

RUN apt-get uppdate && \
    apt-get upgrade && \
    apt-get install sudo python3.6 git curl -y

RUN curl https://raw.githubusercontent.com/jupyterhub/the-littlest-jupyterhub/master/bootstrap/bootstrap.py | sudo -E python3 - --admin hubAdmin
    
EXPOSE 8000

WORKDIR $HOME

CMD /bin/bash
