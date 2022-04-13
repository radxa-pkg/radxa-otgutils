#!/bin/bash -e

configfs_init()
{
    modprobe libcomposite

    case "$MODE" in
        adbd)
            local VENDOR="0x18d1"
            local PRODUCT="0x0001"
            ;;
        usbnet)
            local VENDOR="0x1d6b"
            local PRODUCT="0x0104"
            ;;
    esac

    mkdir -p /sys/kernel/config/usb_gadget/radxa-$MODE -m 0770
    echo "$VENDOR" > /sys/kernel/config/usb_gadget/radxa-$MODE/idVendor
    echo "$PRODUCT" > /sys/kernel/config/usb_gadget/radxa-$MODE/idProduct
    mkdir -p /sys/kernel/config/usb_gadget/radxa-$MODE/strings/0x409 -m 0770
    echo "Radxa" > /sys/kernel/config/usb_gadget/radxa-$MODE/strings/0x409/manufacturer
    echo "$MODE" > /sys/kernel/config/usb_gadget/radxa-$MODE/strings/0x409/product
    mkdir -p /sys/kernel/config/usb_gadget/radxa-$MODE/configs/r.1 -m 0770

    case "$MODE" in
        adbd)
            echo "0123456789ABCDEF" > /sys/kernel/config/usb_gadget/radxa-$MODE/strings/0x409/serialnumber
            mkdir -p /sys/kernel/config/usb_gadget/radxa-$MODE/configs/r.1/strings/0x409 -m 0770
            echo "500" > /sys/kernel/config/usb_gadget/radxa-$MODE/configs/r.1/MaxPower
            echo "adb" > /sys/kernel/config/usb_gadget/radxa-$MODE/configs/r.1/strings/0x409/configuration
            ;;
    esac
}

function_init()
{
    case "$MODE" in
        adbd)
            local GADGET="ffs.adb"
            ;;
        usbnet)
            local GADGET="ecm.usb0"
            ;;
    esac

    if [ ! -e "/sys/kernel/config/usb_gadget/radxa-$MODE/configs/r.1/$GADGET" ];
    then
        mkdir -p /sys/kernel/config/usb_gadget/radxa-$MODE/functions/$GADGET
        ln -s /sys/kernel/config/usb_gadget/radxa-$MODE/functions/$GADGET /sys/kernel/config/usb_gadget/radxa-$MODE/configs/r.1
    fi
}

start()
{
    configfs_init
    function_init

    case "$MODE" in
        adbd)
            if [ ! -e "/dev/usb-ffs/adb" ] ;
            then
                mkdir -p /dev/usb-ffs/adb
                mount -o uid=2000,gid=2000 -t functionfs adb /dev/usb-ffs/adb
            fi
            export service_adb_tcp_port=5555
            start-stop-daemon --start --oknodo --pidfile /var/run/adbd.pid --startas /usr/bin/adbd --background
            sleep 1
            ;;
    esac

    local UDC=$(ls /sys/class/udc/ | head -1)
    echo $UDC > /sys/kernel/config/usb_gadget/radxa-$MODE/UDC
)

stop()
{
    echo "none" > /sys/kernel/config/usb_gadget/radxa-$MODE/UDC
    case "$MODE" in
        adbd)
            start-stop-daemon --stop --oknodo --pidfile /var/run/adbd.pid --retry 5
            ;;
    esac
}

MODE=
case "$(basename $0)" in
    radxa-adbd.sh)
        MODE=adbd
        ;;
    radxa-usbnet.sh)
        MODE=usbnet
        ;;
    radxa-otgutils.sh)
        echo Please run this script from symbolic links.
        exit 1
        ;;
    *)
        echo Unknown script name.
        exit 1
        ;;
esac

case "$1" in
start)
    start
    ;;
stop)
    stop
    ;;
restart|reload)
    stop
    start
    ;;
*)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
