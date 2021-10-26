#!/bin/bash

#
# Update PJSIP
#
cd deps || exit

PJSIP_VERSION=2.10
PJSIP_URL="https://github.com/pjsip/pjproject/archive/$PJSIP_VERSION.tar.gz"

echo "Preparing PJSIP sources..."
if [ ! -f 2.10.tar.gz ]; then
    echo Downloading PJSIP 2.10...
    if wget "$PJSIP_URL"; then
        echo "PJSIP downloaded"
    else
        echo "Fail to download PJSIP"
        exit 1
    fi
fi

tar xzf 2.10.tar.gz
mv pjproject-$PJSIP_VERSION pjsip

#
# Update ZSRTP
#

ZSRTP_ROOT=./pjsip/third_party/zsrtp
ZRTP_ROOT="$ZSRTP_ROOT/zrtp"

# Copy wrapper from old version to third_party/zsrtp/
echo "Preparing ZRTP sources..."
mkdir -p $ZSRTP_ROOT

# Clone latest version from github
if [ ! -d ZRTPCPP ]; then
    echo Downloading ZRTP...
    if git clone https://github.com/wernerd/ZRTPCPP.git "$ZRTP_ROOT"; then
        echo "ZRTP downloaded"
        pushd "$ZRTP_ROOT" || exit
        git checkout 6b3cd8e6783642292bad0c21e3e5e5ce45ff3e03
        popd || exit
    else
        echo Fail to download ZRTP
        exit 1
    fi
fi

cp -r zsrtp/include ./pjsip/third_party/zsrtp/
cp -r zsrtp/srtp    ./pjsip/third_party/zsrtp/
cp -r zsrtp/build   ./pjsip/third_party/build/zsrtp

for p in patches/*.patch; do
    echo "Applying patch $p"
    patch -p0 < "$p" > /dev/null
done

cd - > /dev/null || exit
