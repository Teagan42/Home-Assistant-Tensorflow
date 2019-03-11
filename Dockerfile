ARG HA_VERSION=0.88.1
FROM homeassistant/home-assistant:${HA_VERSION}

# Assign these arguments for appropriate wheel from https://github.com/evdcush/TensorFlow-wheels
ARG TF_VERSION=1.8
ARG PY_VERSION=36
ARG CPU=westmere

ENV HA_VERSION=${HA_VERSION}
ENV TF_VERSION=${TF_VERSION}
ENV PY_VERSION=${PY_VERSION}
ENV CPU=${CPU}
RUN if [ "${PY_VERSION}" = "37" ] ; \
    then \
        add-apt-repository 'deb http://http.us.debian.org/debian testing main non-free contrib'; \
        add-apt-repository 'deb-src http://http.us.debian.org/debian testing main non-free contrib'; \
        apt-get install -y -t testing libstdc++6; \
        apt-get install -y -t testing libc6; \
        pip3 install --no-cache-dir https://github.com/evdcush/TensorFlow-wheels/releases/download/tf-${TF_VERSION}.0-py${PY_VERSION}-cpu-${CPU}/tensorflow-${TF_VERSION}.0-cp${PY_VERSION}-cp${PY_VERSION}m-linux_x86_64.whl; \
    else \
        pip3 install --no-cache-dir https://github.com/evdcush/TensorFlow-wheels/releases/download/tf-${TF_VERSION}-cpu-${CPU}/tensorflow-${TF_VERSION}.0-cp${PY_VERSION}-cp${PY_VERSION}m-linux_x86_64.whl; \
    fi; \
    pip3 install opencv-python
    
RUN apt-get update; \
    apt-get install -y cmake

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
