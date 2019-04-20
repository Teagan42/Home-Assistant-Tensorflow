# Change this path to your config directory
CONFIG_DIR=${1:-"/config"}

cd /tmp

# Install LIBC6
curl -OL http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/libc6_2.27-3ubuntu1_amd64.deb
curl -OL http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/libc6-dev_2.27-3ubuntu1_amd64.deb
curl -OL http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/libc-bin_2.27-3ubuntu1_amd64.deb

apt-get install -fy ./libc6_2.27-3ubuntu1_amd64.deb
apt-get install -fy ./libc6-dev_2.27-3ubuntu1_amd64.deb
apt-get install -fy ./libc-bin_2.27-3ubuntu1_amd64.deb

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

