#!/bin/bash
# droid-hal device add script
# Copyright (c) 2014 Jolla Ltd.
# Contact: Simonas Leleiva <simonas.leleiva@jollamobile.com>

if [ -z $DEVICE ]; then
    echo 'Error: $DEVICE is undefined. Please run hadk'
    exit 1
fi

ROOTFS_DIR=device-$VENDOR-$DEVICE-configs
PATTERNS_DIR=patterns
PATTERNS_DEVICE_DIR=$PATTERNS_DIR/$DEVICE
PATTERNS_TEMPLATES_DIR=$PATTERNS_DIR/templates

if [ ! -d rpm/$PATTERNS_TEMPLATES_DIR ]; then
    echo $0: launch this script from the $ANDROID_ROOT directory
    exit 1
fi

cd rpm/

if [ -e $ROOTFS_DIR ]; then
    read -p "Device $DEVICE appears to be already created. Re-generate patterns? [Y/n] " -n 1 -r
    REPLY=${REPLY:-Y}
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo $ROOTFS_DIR/
    mkdir -p $ROOTFS_DIR
fi

echo Creating the following nodes:

echo $PATTERNS_DEVICE_DIR/

mkdir -p $PATTERNS_DEVICE_DIR

for pattern in $(find $PATTERNS_DIR/{common,hybris,templates} -name *.yaml); do
    PATTERNS_FILE=$(echo $PATTERNS_DEVICE_DIR/$(basename $pattern) | sed -e "s|@DEVICE@|$DEVICE|g")
    echo $PATTERNS_FILE
    cat <<'EOF' >$PATTERNS_FILE
# Feel free to disable non-critical HA parts during devel by commenting out
# Generated in hadk by executing: cd $ANDROID_ROOT; rpm/helpers/add_new_device.sh

EOF
    sed -e 's|@DEVICE@|'$DEVICE'|g' $pattern >>$PATTERNS_FILE
done

cd ..

