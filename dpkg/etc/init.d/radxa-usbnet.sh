#!/bin/bash

configfs_init()
{
    modprobe libcomposite
	mkdir -p /sys/kernel/config/usb_gadget/radxa -m 0770
	echo 0x1d6b > /sys/kernel/config/usb_gadget/radxa/idVendor
	echo 0x0104 > /sys/kernel/config/usb_gadget/radxa/idProduct
	mkdir -p /sys/kernel/config/usb_gadget/radxa/strings/0x409 -m 0770
	echo "Radxa"  > /sys/kernel/config/usb_ga dget/radxa/strings/0x409/manufacturer
	echo "Ethernet Control Model"  > /sys/kernel/config/usb_gadget/radxa/strings/0x409/product
	mkdir -p /sys/kernel/config/usb_gadget/radxa/configs/r.1 -m 0770
}

function_init()
{
    if [ ! -e "/sys/kernel/config/usb_gadget/radxa/configs/r.1/ecm.usb0" ];
    then
        mkdir -p /sys/kernel/config/usb_gadget/radxa/functions/ecm.usb0
        ln -s /sys/kernel/config/usb_gadget/radxa/functions/ecm.usb0 /sys/kernel/config/usb_gadget/radxa/configs/r.1
    fi
}

start()
{
    configfs_init
	function_init

	UDC=$(ls /sys/class/udc/ | head -1)
	echo $UDC > /sys/kernel/config/usb_gadget/radxa/UDC
}

stop()
{
	echo "none" > /sys/kernel/config/usb_gadget/radxa/UDC
}

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
