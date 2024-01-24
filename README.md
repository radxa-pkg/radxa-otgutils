# radxa-otgutils

[![Build & Release](https://github.com/radxa-pkg/radxa-otgutils/actions/workflows/release.yml/badge.svg)](https://github.com/radxa-pkg/radxa-otgutils/actions/workflows/release.yml)

Radxa USB OTG utility (radxa-otgutils) provides additional features over USB OTG port to facilitate easy cmmunication with another computer.

# Usage

The following gadgets are supported:

- radxa-adbd
- radxa-usbnet

They can be enabled with `sudo systemctl enable --now <gadget>`, and disabled with `sudo systemctl disable --now <gadget>`.

Please be aware than those gadgets are mutually exclusive. If one is already enabled you have to diable then reboot before you can enable anyther gadget.
