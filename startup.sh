# Change this path to your config directory
CONFIG_DIR=${1:-"/config"}
WORK_DIR=${2:="/usr/src/app"}

cd /tmp

apt-get update
apt-get install -fy libc6 libc6-dev libc-bin git unzip

# Clone the latest code from GitHub
/usr/bin/git clone --depth 1 https://github.com/tensorflow/models.git tensorflow-models

# download protobuf 3.4
curl -OL https://github.com/google/protobuf/releases/download/v3.4.0/protoc-3.4.0-linux-x86_64.zip
/usr/bin/unzip -a protoc-3.4.0-linux-x86_64.zip -d protobuf
mv protobuf/bin /tmp/tensorflow-models/research

# Build the protobuf models
cd /tmp/tensorflow-models/research/
./bin/protoc object_detection/protos/*.proto --python_out=.

# Copy only necessary files
rm -rf ${CONFIG_DIR}/tensorflow/object_detection
mkdir -p ${CONFIG_DIR}/tensorflow/object_detection
touch ${CONFIG_DIR}/tensorflow/object_detection/__init__.py

mv object_detection/data ${CONFIG_DIR}/tensorflow/object_detection
mv object_detection/utils ${CONFIG_DIR}/tensorflow/object_detection
mv object_detection/protos ${CONFIG_DIR}/tensorflow/object_detection

# Cleanup
echo "Cleaning up"
rm -rf /tmp/*

cd ${WORK_DIR}
exec "python -m homeassistant --config ${CONFIG_DIR}"
