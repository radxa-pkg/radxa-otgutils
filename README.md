# radxa-usbnet
Enable USB ethernet gadget on selected Radxa single board computers.

# Install
Install with `sudo apt install radxa-usbnet`. Alternatively download the [latest release](https://github.com/RadxaYuntian/radxa-usbnet/releases/latest) and install with `sudo apt install ./dpkg.deb`.

# Usage
This service conflicts with `amlogic-adbd`. As such please run the following command to enable it:
```
sudo systemctl disable amlogic-adbd
sudo systemctl enable radxa-usbnet
sudo reboot # need to reboot to free the USB resource
```