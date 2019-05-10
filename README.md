# otg-set-mode.sh

A BASH script used to set the USB OTG gadget mode on a Raspberry Pi.

The USB port on a Raspberry Pi normally operates in host mode and accepts 
devices such as a USB keyboard, USB flash drive, USB ethernet, etc. However, 
it is possible to have the Raspberry Pi act as a USB device in place of a 
host.

The Raspberry Pi can act as a USB ethernet device, USB serial port, etc.


# usage

Use sudo to run the BASH script from the command line...
> sudo ./otg-set-mode.sh [mode]

The default mode is g_ether if no mode parameter is provided.

Other possible modes include:
* Serial (g_serial)
* Ethernet (g_ether)
* Mass storage (g_mass_storage)
* MIDI (g_midi)
* Audio (g_audio)
* Keyboard/Mouse (g_hid)
* Mass storage and Serial (g_acm_ms)
* Ethernet and Serial (g_cdc)
* Multi (g_multi) - Allows you to configure 2 from Ethernet, Mass storage and Serial
* Webcam (g_webcam)
* Printer (g_printer)
* Gadget tester (g_zero)

After running the script the changes will take effecgt after the next reboot.


# file changes

The script will modify two files on the boot partition to enable the selected OTG mode. 

A kernel modules-load parameter is added to /boot/cmdline.txt to load the dwc2 module 
when the kernel loads. I.E.
> modules-load=dwc2,g_ether

And a dtoverlay setting is added to /boot/config.txt to configure the device tree for 
OTG mode when the Raspberry Pi boots. I.E.
> dtoverlay=dwc2


# post boot setup

Additional setup may be needed to take advantage of the new OTG device settings. I.E.

When using the g_serial mode it may be desirable to attach a console to the new USB 
serial device. The following command will enable the serial console...
> sudo systemctl enable getty@ttyGS0.service

If the mode is set to g_ether then it may be desirable to configure an IP address on 
the USB ethernet device and install a DHCP server so the Raspberry Pi can provide an 
IP address to any system that connects to the USB port.

