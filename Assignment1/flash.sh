#!/bin/bash 

BASE="./e16_01_setup_system.yml ./e16_02_write_system_files.yml ./e16_03_write_vpn_files.yml ./e16_04_write_startup_files.yml ./e16_05_once_only_commands.yml"

CMD="cat $BASE > ./hypriot.yml"

echo creating cloud-init file... 
echo $CMD
eval $CMD

CMD="flash --device /dev/disk$1 --metadata ./metadata.txt --userdata ./hypriot.yml --bootconf ./config.txt https://www.dropbox.com/s/kr7po419adjsfoc/hypriotos-rpi64-e16-20190305.img.zip?dl=1"

echo executing... 
echo $CMD
eval $CMD
