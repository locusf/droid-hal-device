#!/bin/sh
DROID_BIN="/usr/libexec/droid-hybris/system/bin"
PATCHRAM_ARGS="--patchram /system/vendor/firmware/bcm4330.hcd \
                --no2bytes \
                --i2s=1,1,0,1 \
                --enable_hci \
                --enable_lpm \
                --baudrate 3000000 --use_baudrate_for_download \
                --tosleep=50000"
BT_ADDR=`cat /factory/bluetooth/bt_addr`
echo $BT_ADDR > /var/lib/bluetooth/board-address


if [ -f $DROID_BIN/rfkill ]; then
    $DROID_BIN/rfkill unblock bluetooth
else
    rfkill unblock bluetooth
fi

if [ -f $DROID_BIN/brcm_patchram_plus ]; then
    $DROID_BIN/brcm_patchram_plus $PATCHRAM_ARGS --bd_addr $BT_ADDR /dev/ttyO1
else
    brcm_patchram_plus $PATCHRAM_ARGS --bd_addr $BT_ADDR /dev/ttyO1
fi
