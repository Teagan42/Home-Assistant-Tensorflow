FROM ubuntu:18.04

ARG HA_VERSION=0.88.1

# Install python deps
RUN apt-get update; \
    apt-get install -y python3.7-dev python3-pip python3

RUN pip3 install pip six numpy wheel mock; \
    pip3 install keras_applications==1.0.6 --no-deps; \
    pip3 install keras_preprocessing==1.0.5 --no-deps

# Install Bezel
RUN apt-get install -y pkg-config zip g++ zlib1g-dev unzip python curl bash-completion; \
    cd /tmp; \
    curl -sLO https://github.com/bazelbuild/bazel/releases/download/0.21.0/bazel_0.21.0-linux-x86_64.deb && dpkg -i bazel_0.21.0-linux-x86_64.deb

# Install Tensorflow
RUN apt-get update; \
    apt-get install -y git gcc-7 g++-7 gcc-8 g++-8; \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 100 --slave /usr/bin/g++ g++ /usr/bin/g++-8; \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7; \
    update-alternatives --config gcc; \
    cd /tmp; \
    git clone https://github.com/tensorflow/tensorflow.git; \
    cd tensorflow; \
    bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package; \
    ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg; \
    ls -t /tmp/tensorflow_pkg/tensorflow*.whl | head -1 | pip3 install ; \
    pip3 install opencv-python

# Install Home-Assistant
RUN python3 -m pip install homeassistant==${HA_VERSION}

CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
