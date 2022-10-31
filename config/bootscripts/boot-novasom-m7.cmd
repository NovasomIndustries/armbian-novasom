setenv load_addr "0x39000000"
setenv overlay_error "false"
# default values
setenv rootdev "/dev/mmcblk0p1"
setenv verbosity "1"
setenv rootfstype "ext4"
setenv prefix "/boot/"
setenv fdtfile "rk3328-novasomm7.dtb"
setenv kernel_comp_addr_r 0x19000000
setenv kernel_comp_size 0x04000000

echo "NOVAsom M7 Boot script loaded from ${devtype} ${devnum}"

if test "${logo}" = "disabled"; then setenv logo "logo.nologo"; fi
if test -e ${devtype} ${devnum} ${prefix}armbianEnv.txt; then
        load ${devtype} ${devnum} ${load_addr} ${prefix}armbianEnv.txt
        env import -t ${load_addr} ${filesize}
fi


setenv consoleargs "console=tty1 console=ttyFIQ0,115200 earlyprintk=uart8250-32bit,0xff130000"

# get PARTUUID of first partition on SD/eMMC the boot script was loaded from
if test "${devtype}" = "mmc"; then part uuid mmc ${devnum}:1 partuuid; fi

setenv bootargs "root=${rootdev} rootwait rootfstype=${rootfstype} ${consoleargs} panic=10 consoleblank=0 loglevel=${verbosity} ubootpart=${partuuid} usb-storage.quirks=${usbstoragequirks} ${extraargs} ${extraboardargs} earlyprintk=uart8250-32bit,0xff130000"

fdt addr ${fdt_addr_r}
load ${devtype} ${devnum} ${ramdisk_addr_r} ${prefix}uInitrd
load ${devtype} ${devnum} ${kernel_addr_r} ${prefix}Image
load ${devtype} ${devnum} ${fdt_addr_r} ${prefix}dtb/rockchip/${fdtfile}
booti ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr_r}

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr


