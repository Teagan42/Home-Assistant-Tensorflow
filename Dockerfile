ARG HA_VERSION=0.86.1
FROM homeassistant/home-assistant:${VERSION}

ARG TF_VERSION=1.8
ARG PYTHON_VERSION=36
ARG CPU=westmere

RUN pip3 install --no-cache-dir https://github.com/evdcush/TensorFlow-wheels/releases/download/tf-${TF_VERSION}-cpu-${CPU}/tensorflow-${TF_VERSION}-cp${PYTHON_VERSION}-cp${PYTHON_VERSION}m-linux_x86_64.whl; \
    pip3 install opencv-python

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
