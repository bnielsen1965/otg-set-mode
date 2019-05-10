#!/bin/bash

# The author has placed this work in the Public Domain, thereby relinquishing all
# copyrights. Everyone is free to use, modify, republish, sell or give away this
# work without prior consent from anybody.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHOR(S) OR CONTRIBUTOR(S)
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
# THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Set the OTG mode on a Raspberry Pi to allow the Pi to be detected as a USB device.
# Default mode is ethernet or the desired mode can be specified as an arguement. I.E.
# sudo ./otg-set-mode.sh g_serial
#
# Possible modes:
# Serial (g_serial)
# Ethernet (g_ether)
# Mass storage (g_mass_storage)
# MIDI (g_midi)
# Audio (g_audio)
# Keyboard/Mouse (g_hid)
# Mass storage and Serial (g_acm_ms)
# Ethernet and Serial (g_cdc)
# Multi (g_multi) - Allows you to configure 2 from Ethernet, Mass storage and Serial
# Webcam (g_webcam)
# Printer (g_printer)
# Gadget tester (g_zero)
#


# default mode when not provided on the command line
DEFAULT_MODE="g_ether"
OTG_MODE="$1"
OTG_MODE="${OTG_MODE:="$DEFAULT_MODE"}"

# location of the kernel boot cmdline parameters
KERNEL_CMDLINE="/boot/cmdline.txt"
MODULES_LOAD_DWC2="modules-load=dwc2"

# create backup and remove any old module load setting and add the new module load setting
sed -i.backup \
-e "s/[[:space:]]*$MODULES_LOAD_DWC2[^[:space:]]*\([[:space:]]*\)/\1/g" \
-e "s/$/ $MODULES_LOAD_DWC2,$OTG_MODE/" \
"$KERNEL_CMDLINE"

# location of Raspberry Pi boot config
BOOT_CONFIG="/boot/config.txt"
OVERLAY_DWC2="dtoverlay=dwc2"

# create backup and remove any old dwc2 overlay setting
sed -i.backup \
-e "s/^[[:space:]]*$OVERLAY_DWC2.*$//g" \
"$BOOT_CONFIG"

# add the dwc2 dtoverlay setting
echo "$OVERLAY_DWC2" >> "$BOOT_CONFIG"
