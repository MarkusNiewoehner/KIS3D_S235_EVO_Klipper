compile_skr_pro_12() {
    echo "Compiling firmware for SKR Pro 1.2"
    cp -f /home/pi/klipper_config/config/boards/btt-skr-pro-12/firmware.config /home/pi/klipper/.config
    make olddefconfig
    make clean
    make
    cp /home/pi/klipper/out/klipper.bin /home/pi/klipper_config/firmware_binaries/firmware-btt-skr-pro-12.bin
}

# Force script to exit if an error occurs
set -e

if [ ! -d "/home/pi/klipper_config/firmware_binaries" ]
then
    mkdir /home/pi/klipper_config/firmware_binaries
    chown pi:pi /home/pi/klipper_config/firmware_binaries
fi


pushd /home/pi/klipper

# Run make scripts for the supported boards.
compile_skr_pro_12

chown pi:pi /home/pi/klipper_config/firmware_binaries/*.bin

popd