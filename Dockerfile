# Notice:
# When updating this file, please also update virtualization/Docker/Dockerfile.dev
# This way, the development image and the production image are kept in sync.

FROM python:3.6

ARG HA_VERSION=0.88.1

# Uncomment any of the following lines to disable the installation.
ENV INSTALL_TELLSTICK no
ENV INSTALL_OPENALPR no
#ENV INSTALL_FFMPEG no
ENV INSTALL_LIBCEC no
ENV INSTALL_SSOCR no
#ENV INSTALL_DLIB no
ENV INSTALL_IPERF3 no

VOLUME /config

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y curl ldap-utils git vim curl unzip

RUN git clone --branch ${HA_VERSION} https://www.github.com/home-assistant/home-assistant . && \
    /bin/bash virtualization/Docker/setup_docker_prereqs && \
    pip3 install --no-cache-dir -r requirements_all.txt && \
    pip3 install --no-cache-dir mysqlclient psycopg2 uvloop==0.12.2 cchardet cython

RUN cd /tmp; \
    curl -LO https://github.com/evdcush/TensorFlow-wheels/releases/download/tf-1.12.0-py37-cpu-westmere/tensorflow-1.12.0-cp37-cp37m-linux_x86_64.whl; \
    pip3 install --no-cache-dir tensorflow-1.12.0-cp37-cp37m-linux_x86_64.whl; \
    pip3 install opencv-python 

COPY tensorflow_setup.sh tensorflow_setup.sh

RUN /bin/bash tensorflow_setup.sh

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
