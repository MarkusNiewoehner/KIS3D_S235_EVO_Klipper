### Welcome to the Klipper configuration for the KIS3D S235 EVO tripple Z
#### this is a private repository, it has no relation to the printer manufacturer
![](https://github.com/MarkusNiewoehner/KIS3D_S235_EVO_Klipper/blob/main/images/S235EVO.png)
<br>
`<link>` : <http://kis3d.de>

------------

##### Hardware configuration on which this klipper config is based:
- SKR Pro1.2 & TMC2209
- Raspberry 4b
- BTT PiTFT Display
- 4 Channel Relay to manage Fans and LED
- X, Y Axis LDO 42STH48-2504AC 1,8° stepper
- Bondtech LGX lite Extruder
- Phaetus BMO dragonfly Hotend
- ADXL345 accelometer for input shaping
- Lerdge Relay Module for shutdown mains after print and cooldown
- Backupfunction macro to USB Stick for all config files
- intelligent macro for PID tuning. Typ in the temp - under 90°C it will attemped Bed PID, above - Extruder PID
------------
##### Install manual for the backupscript:
usbmount install on Raspberry Pi


    sudo apt update
        sudo apt dist-upgrade
        
        sudo apt install usbmount
        
        edit usbmount.conf 
        sudo nano /etc/usbmount/usbmount.conf

find this:


     FS_MOUNTOPTIONS=""

edit to:


    FS_MOUNTOPTIONS="-fstype=vfat,gid=users,dmask=0007,fmask=0111"

open this:


    sudo nano /lib/systemd/system/systemd-udevd.service

find this:


     PrivateMounts=yes
edit to:


    PrivateMounts=no
System reboot:


    sudo reboot

switch to pi home and create the  backup script file


    cd /home/pi
        sudo nano backup-klipper.sh
paste into this script:


    #!/bin/bash
        tar -cPvf /media/usb/backup-klipper_`date +"%Y-%m-%d_%H-%M"`.tar /home/pi/klipper_config
        exit 0
it is just a suggestion, the directories can be further customized

make the script executeable


    sudo chmod +x backup-klipper.sh 
paste this macro into your printer.cfg


    [gcode_shell_command backup_klipper]
        command: /home/pi/backup-klipper.sh
        timeout: 120.
        verbose: True
        
    [gcode_macro backup]
        gcode:
        RUN_SHELL_COMMAND CMD=backup_klipper



in mainsail you will now see the "backup" button in the macros, you can press this to save, you can see the output in the console.
if you don't want any output, remove the "v" from "tar -cPvf" in the shellscript.
