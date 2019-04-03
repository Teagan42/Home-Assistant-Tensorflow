ARG HA_VERSION=0.88.1
FROM homeassistant/home-assistant:${HA_VERSION}

# Install Tensorflow Whell
RUN cd /tmp; \
    curl -LO https://github.com/evdcush/TensorFlow-wheels/releases/download/tf-1.12.0-py37-cpu-westmere/tensorflow-1.12.0-cp37-cp37m-linux_x86_64.whl; \
    pip3 install --no-cache-dir tensorflow-1.12.0-cp37-cp37m-linux_x86_64.whl; \
    pip3 install opencv-python 

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
