# radxa-otgutils

[![Build](https://github.com/radxa-pkg/radxa-otgutils/actions/workflows/build.yml/badge.svg)](https://github.com/radxa-pkg/radxa-otgutils/actions/workflows/build.yml) [![Release](https://github.com/radxa-pkg/radxa-otgutils/actions/workflows/release.yml/badge.svg)](https://github.com/radxa-pkg/radxa-otgutils/actions/workflows/release.yml)

Enable USB gadget on OTG port.

# Usage

The following gadgets are provided:
* radxa-adbd
* radxa-usbnet

They can be enabled with `sudo systemctl enable --now <gadget>`, and disabled with `sudo systemctl disable --now <gadget>`.

Please be aware than those gadgets are mutually exclusive. If one is already enabled you have to diable then reboot before you can enable anyther gadget.