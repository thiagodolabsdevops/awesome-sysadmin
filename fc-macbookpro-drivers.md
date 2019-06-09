The current kernel/drivers of Fedora do not support the Wifi chip used on Mac Book Pro. Proprietary Broadcom drivers are packaged and available in the rpmfusion repo.
 
Verify that your card is a Broadcom using: `lspci -vnn -d 14e4:`

**Sample output:**

    02:00.0 Network controller [0280]: Broadcom Corporation BCM4360 802.11ac Wireless Network Adapter [14e4:43a0] (rev 03)

## Install
Install the [rpmfusion](http://rpmfusion.org/) repo, note only "nonfree" is required, as the Broadcom Driver is proprietry: http://rpmfusion.org/

    su -c 'dnf install -y http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'

Then install the `akmods` and `kernel-devel` packages:

    sudo dnf install -y akmods "kernel-devel-uname-r == $(uname -r)"


Finally install `broadcom-wl` package from the rpmfusion repo, which will install kmod-wl, akmod-wl, and other dependencies.

    sudo dnf install -y broadcom-wl

Next run `akmods` to rebuild the kernel extension in the `broadcom-wl` package:

    sudo akmods

Finally, `reboot` Fedora.


## Troubleshooting

- `lsmod` to list all kernel modules
- `sudo modprobe wl` will force the wireless kernel extension to load.
- `sudo systemctl restart NetworkManager`
