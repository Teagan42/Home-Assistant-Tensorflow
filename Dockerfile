ARG HA_VERSION=0.88.1
FROM homeassistant/home-assistant:${HA_VERSION}

# Install Bazel
RUN apt-get update; \
    apt-get install -y openjdk-8-jdk curl gnupg gnupg2 gnupg1 git software-properties-common; \
    add-apt-repository "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8"; \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add -; \
    apt-get update; \
    apt-get install -y bazel

# Install Tensorflow Whell
RUN cd /temp; \
    curl -LO https://github.com/evdcush/TensorFlow-wheels/releases/download/tf-1.12.0-py37-cpu-westmere/tensorflow-1.12.0-cp37-cp37m-linux_x86_64.whl; \
    pip3 install --no-cache-dir tensorflow-1.12.0-cp37-cp37m-linux_x86_64.whl; \
    apt-get install -y protobuf-compiler python-pil python-lxml python-tk; \
    pip3 install Cythonl; \
    pip3 install contextlib2; \
    pip3 install jupyter; \
    pip3 install matplotlib; \
    pip3 install opencv-python 

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
