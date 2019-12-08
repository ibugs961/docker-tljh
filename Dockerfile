FROM debian:buster

MAINTAINER AIE Group

USER root
ENV LANG=en_US.UTF-8
ENV JUPYTER_TOKEN aec7d32df938c0f55e54f09244a350cb29ea612907ed4f07be13d9553d18a8e4

RUN . /etc/os-release && \
    echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib \
    deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib \
    deb http://mirrors.aliyun.com/debian-security buster/updates main \
    deb-src http://mirrors.aliyun.com/debian-security buster/updates main \
    deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib \
    deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib \
    deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib \
    deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" > /etc/apt/sources.list

RUN mkdir -p /root/.pip && \
    echo "[global]\n\
    index-url = https://mirrors.aliyun.com/pypi/simple/" > /root/.pip/pip.conf

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install --no-install-recommends -y \
        locales \
        curl \
        gcc \
        make \
        procps \
        python3.7 \
        python3.7-distutils \
        libpython3.7-dev \
        build-essential && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1 && \
    ln -s /usr/bin/python3 /usr/local/bin/python3

RUN echo insecure >> ~/.curlrc && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py
    
RUN apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    locale-gen && \
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf && \
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen

RUN python3 -m pip install -U \
    scikit-learn==0.22 \
    lightgbm==2.2.3 \
    xgboost==0.90 \
    matplotlib==3.1.2 \
    seaborn==0.9.0 \
    hdfs==2.5.8 \
    nbparameterise==0.3 \
    pysftp==0.2.8 \
    pycrypto==2.6.1 \
    tornado==6.0.3 \
    notebook==6.0.0 \
    pystan==2.18.0.0

RUN python3 -m pip install -U \   
    fbprophet==0.4.post2

RUN mkdir /home/jovyan && \
    rm -r ~/.cache/pip

RUN curl -O http://ftp.br.debian.org/debian/pool/main/s/sqlite3/sqlite3_3.27.2-3_amd64.deb && \
    dpkg -i sqlite3_3.27.2-3_amd64.deb

RUN curl -O http://ftp.debian.org/debian/pool/main/l/linux/linux-libc-dev_4.19.67-2+deb10u2_amd64.deb && \
    dpkg -i linux-libc-dev_4.19.67-2+deb10u2_amd64.deb

EXPOSE 8888

CMD jupyter notebook --NotebookApp.token=$JUPYTER_TOKEN --notebook-dir=/home/jovyan --ip='*' --port=8888 --no-browser --allow-root
