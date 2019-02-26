ARG HA_VERSION=0.88.1
FROM homeassistant/home-assistant:${HA_VERSION}

# Assign these arguments for appropriate wheel from https://github.com/evdcush/TensorFlow-wheels
ARG TF_VERSION=1.8
ARG PY_VERSION=36
ARG CPU=westmere

RUN pip3 install --no-cache-dir https://github.com/evdcush/TensorFlow-wheels/releases/download/tf-${TF_VERSION}-cpu-${CPU}/tensorflow-${TF_VERSION}.0-cp${PY_VERSION}-cp${PY_VERSION}m-linux_x86_64.whl; \
    pip3 install opencv-python

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
