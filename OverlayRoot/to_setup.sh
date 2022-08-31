# shellcheck shell=sh
# sh this_file.sh # this script creates the filetree needed to overlay / and LinuxExtRoot for ovroot

#$ sudo tree /mnt/Extended/LinuxExtRoot -pug --metafirst                                                           
# [drwxr-xr-x root  root ]  /mnt/Extended/LinuxExtRoot
# [drwxr-xr-x root  root ]  ├── ovroot
# [drwxr-xr-x root  root ]  └── ovroot_uw
# [-rwxr-xr-x root  root ]      ├── chroot
# [-rw-r--r-- root  root ]      └── to_setup.sh

this_file="$(readlink -f "$0")"
chroot_file="$(dirname "$this_file")/chroot"

cd /mnt/Extended/LinuxExtRoot || ( echo 'Extended partition not mounted OR No file tree found' && exit )

sudo -s -- <<EOC
mkdir ovroot
mkdir ovroot_uw
cp "$this_file" "$chroot_file" ./ovroot_uw/
chmod +x ./ovroot_uw/chroot

EOC
