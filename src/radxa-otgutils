#!/bin/bash -e

lock_udc()
{
    configfs_make
    exec 100<"/sys/kernel/config/usb_gadget/$UDC"
    flock 100
}

unlock_udc()
{
    exec 100<&-
}

enable_udc()
{
    if [[ -n $(cat "/sys/kernel/config/usb_gadget/$UDC/UDC") ]];
    then
        echo "" > "/sys/kernel/config/usb_gadget/$UDC/UDC"
    fi
    echo "$UDC" > "/sys/kernel/config/usb_gadget/$UDC/UDC"
}

configfs_make()
{
    if [ ! -e "/sys/kernel/config/usb_gadget/$UDC" ];
    then
        modprobe libcomposite
        mkdir -p "/sys/kernel/config/usb_gadget/$UDC"
    fi
}

configfs_init()
{
    pushd "/sys/kernel/config/usb_gadget/$UDC"

    echo "0x1d6b" > "idVendor"  # Linux Foundation
    echo "0x0104" > "idProduct" # Multifunction Composite Gadget
    echo "0x0100" > "bcdDevice" # v1.0.0
    echo "0x0200" > "bcdUSB"    # USB 2.0
    echo "0xEF" > "bDeviceClass"
    echo "0x02" > "bDeviceSubClass"
    echo "0x01" > "bDeviceProtocol"

    mkdir -p "strings/0x409"
    echo "0123456789ABCDEF" > "strings/0x409/serialnumber"
    echo "Radxa" > "strings/0x409/manufacturer"
    echo "OTG Utils" > "strings/0x409/product"

    mkdir -p "configs/r.1/strings/0x409"
    echo "500" > "configs/r.1/MaxPower"
    echo "USB Composite Device" > "configs/r.1/strings/0x409/configuration"

    popd
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

    if [ ! -e "/sys/kernel/config/usb_gadget/$UDC/functions/$GADGET" ];
    then
        mkdir -p "/sys/kernel/config/usb_gadget/$UDC/functions/$GADGET"
    fi

    if [ ! -e "/sys/kernel/config/usb_gadget/$UDC/configs/r.1/$GADGET" ];
    then
        ln -s "/sys/kernel/config/usb_gadget/$UDC/functions/$GADGET" "/sys/kernel/config/usb_gadget/$UDC/configs/r.1/$GADGET"
    fi
}

function_stop()
{
    case "$MODE" in
        adbd)
            local GADGET="ffs.adb"
            ;;
        usbnet)
            local GADGET="ecm.usb0"
            ;;
    esac

    if [ -e "/sys/kernel/config/usb_gadget/$UDC/configs/r.1/$GADGET" ];
    then
        rm "/sys/kernel/config/usb_gadget/$UDC/configs/r.1/$GADGET"
    fi

    if [ -e "/sys/kernel/config/usb_gadget/$UDC/functions/$GADGET" ];
    then
        rmdir "/sys/kernel/config/usb_gadget/$UDC/functions/$GADGET"
    fi
    if [ -n "$(find "/sys/kernel/config/usb_gadget/$UDC/functions" -maxdepth 0 -type d -empty)" ];
    then
        if [ -e "/sys/kernel/config/usb_gadget/$UDC/configs/r.1/strings/0x409" ];
        then
            rmdir "/sys/kernel/config/usb_gadget/$UDC/configs/r.1/strings/0x409"
        fi

        if [ -e "/sys/kernel/config/usb_gadget/$UDC/configs/r.1" ];
        then
            rmdir "/sys/kernel/config/usb_gadget/$UDC/configs/r.1"
        fi

        if [ -e "/sys/kernel/config/usb_gadget/$UDC/strings/0x409" ];
        then
            rmdir "/sys/kernel/config/usb_gadget/$UDC/strings/0x409"
        fi
    else
        enable_udc
    fi
}

start()
{
    lock_udc
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
            start-stop-daemon --start --oknodo --make-pidfile --pidfile /var/run/adbd.pid --startas /usr/bin/adbd --background
            sleep 0.1
            ;;
    esac

    enable_udc
    unlock_udc
}

stop()
{
    lock_udc
    function_stop
    case "$MODE" in
        adbd)
            start-stop-daemon --stop --oknodo --pidfile /var/run/adbd.pid --remove-pidfile --retry 5
            umount /dev/usb-ffs/adb
            rmdir /dev/usb-ffs/adb
            rmdir /dev/usb-ffs
            ;;
    esac
    unlock_udc
}

MODE=""
case "$1" in
adbd|usbnet)
    MODE="$1"
    ;;
*)
    echo "Unknown mode. Valid values are adbd or usbnet."
    echo "Usage: $0 <adbd|usbnet> <UDC> <start|stop|restart>"
    exit 1
esac

UDC=""
if [ -e "/sys/class/udc/$2" ];
then
    UDC="$2"
else
    echo "This UDC does not exist, you can turn on the OTG port Peripheral mode device tree overlay at rsetup and look in the /sys/class/udc directory for."
    echo "Usage: $0 <adbd|usbnet> <UDC> <start|stop|restart>"
    exit 1
fi

case "$3" in
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
    echo "Usage: $0 <adbd|usbnet> <UDC> <start|stop|restart>"
    exit 1
esac

exit 0
