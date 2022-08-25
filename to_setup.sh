# shellcheck shell=sh
# sh this_file.sh # this script creates the filetree structure of Linux Extended Root

#$ sudo tree /mnt/Extended/LinuxExtRoot -pug --metafirst                                                           
# [drwxr-xr-x root  root ]  /mnt/Extended/LinuxExtRoot
# [drwxr-xr-x root  root ]  ├── home
# [drwx------ nkpro nkpro]  │   └── nkpro             # to extend home dir too
# [drwxrwxrwt root  root ]  ├── thome                 # to have seperate home space for apps in this extended partition
# [drwxrwxrwt root  root ]  ├── tusr                  # to have the bins and libraries of apps in this extended partition
# [drwxr-xr-x root  root ]  └── var                   # to store some caches


this_file="$(readlink -f $0)"

cd /mnt/Extended || ( echo 'Extended partition not mounted' && exit )

sudo -s -- <<EOC
mkdir -p /mnt/Extended/LinuxExtRoot

mkdir -p /mnt/Extended/LinuxExtRoot/home
mkdir -p /mnt/Extended/LinuxExtRoot/thome && chmod ugo+rwxt /mnt/Extended/LinuxExtRoot/thome
mkdir -p /mnt/Extended/LinuxExtRoot/tusr  && chmod ugo+rwxt /mnt/Extended/LinuxExtRoot/tusr
mkdir -p /mnt/Extended/LinuxExtRoot/var

EOC

sudo -s eval "mkdir -p /mnt/Extended/LinuxExtRoot/home/${USER} && chmod go-rwx /mnt/Extended/LinuxExtRoot/home/${USER} && chown ${USER}:${USER} /mnt/Extended/LinuxExtRoot/home/${USER}"

sudo -s eval "cp ${this_file} /mnt/Extended/LinuxExtRoot/to_setup.sh ; tree /mnt/Extended/LinuxExtRoot -L 2 -pug --metafirst"
