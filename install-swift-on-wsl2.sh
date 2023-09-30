# Install Swift in WSL2
# Requirements: WindowsOS, WSL2, Some Swift version downloaded to your Windows 'Downloads' folder (Download here: https://www.swift.org/download/)

SWIFT_VERSION="5.8.1"
SWIFT_MAJOR_VERSION="${SWIFT_VERSION:0:1}"
PLATFORM_VERSION="ubuntu22.04"
WINDOWS_USERNAME="jonas"
LINUX_USERNAME="jonas"
WINDOWS_DOWNLOADS_PATH="/mnt/c/Users/$WINDOWS_USERNAME/Downloads"

cd $WINDOWS_DOWNLOADS_PATH
sudo mv swift-$SWIFT_VERSION-RELEASE-$PLATFORM_VERSION.tar.gz /home/$LINUX_USERNAME/Downloads/
cd /home/$LINUX_USERNAME/Downloads/

sudo apt-get install binutils git gnupg2 libc6-dev libcurl4-openssl-dev libedit2 libgcc-9-dev libpython3.8 libsqlite3-0 libstdc++-9-dev libxml2-dev libz3-dev pkg-config tzdata unzip zlib1g-dev
sudo apt-get install libc6

sudo wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import
gpg --keyserver hkp://keyserver.ubuntu.com --refresh-keys Swift
wget -q -O - https://swift.org/keys/release-key-swift-$SWIFT_MAJOR_VERSION.x.asc | gpg --import -
gpg --verify swift-$SWIFT_VERSION-$PLATFORM_VERSION.tar.gz.sig

tar -xzf swift-$SWIFT_VERSION-RELEASE-$PLATFORM_VERSION.tar.gz
sudo rm swift-$SWIFT_VERSION-RELEASE-$PLATFORM_VERSION.tar.gz

cd ..
mkdir -p bin

mv Downloads/swift-$SWIFT_VERSION-RELEASE-$PLATFORM_VERSION bin
echo "export PATH=~/bin/swift-$SWIFT_VERSION-RELEASE-$PLATFORM_VERSION/usr/bin/:'${PATH}';" >> ~/.bashrc
source ~/.bashrc

# DOCKER INSTALL
# docker pull swift
# docker run --privileged --interactive --tty \
# --name swift-latest swift:latest /bin/bash
# docker start swift-latest
# docker attach swift-latest
