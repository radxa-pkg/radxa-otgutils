# radxa-otgutils

[![Build & Release](https://github.com/radxa-pkg/radxa-otgutils/actions/workflows/release.yml/badge.svg)](https://github.com/radxa-pkg/radxa-otgutils/actions/workflows/release.yml)

Radxa USB OTG utility (radxa-otgutils) provides additional features over USB OTG port to facilitate easy communication with another computer.

# Usage

The following gadgets are supported:

- radxa-adbd
- radxa-ecm (previously radxa-usbnet)
- radxa-ncm

They can be configured from [`rsetup`](https://github.com/radxa-pkg/rsetup) which is included in our systems.

Optionally they can be enabled with `sudo systemctl enable --now <gadget>@<udc controller>`, and disabled with `sudo systemctl disable --now <gadget>@<udc controller>`.
