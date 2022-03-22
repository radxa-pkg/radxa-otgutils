# radxa-usbnet

[![Build](https://github.com/radxa-pkg/radxa-usbnet/actions/workflows/build.yml/badge.svg)](https://github.com/radxa-pkg/radxa-usbnet/actions/workflows/build.yml) [![Release](https://github.com/radxa-pkg/radxa-usbnet/actions/workflows/release.yml/badge.svg)](https://github.com/radxa-pkg/radxa-usbnet/actions/workflows/release.yml)

Enable USB ethernet gadget on selected Radxa single board computers

# Usage
This service conflicts with `amlogic-adbd`. As such please run the following command to enable it:
```
sudo systemctl disable amlogic-adbd
sudo systemctl enable radxa-usbnet
```
The device will be available after reboot.