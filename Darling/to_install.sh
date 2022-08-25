# shellcheck shell=sh
# sh this_file.sh

#$ sudo tree /mnt/Extended/LinuxExtRoot -pug --metafirst                                                           
# [drwxr-xr-x root  root ]  /mnt/Extended/LinuxExtRoot
# [drwxr-xr-x root  root ]  ├── home
# [drwx------ nkpro nkpro]  │   └── nkpro             # to extend home dir too
# [drwxrwxrwt root  root ]  ├── thome                 # to have seperate home space for apps in this extended partition
# [drwxrwxrwt root  root ]  ├── tusr                  # to have the bins and libraries of apps in this extended partition
# [drwxr-xr-x root  root ]  └── var                   # to store some caches

## Files related to this script
# [drwxrwxrwt root  root ]  ├── thome
# [drwx------ nkpro nkpro]  │   ├── nkpro_darling
# [drwxr-xr-x nkpro nkpro]  │   │   ├── darling_src_repo
# [-rw-r--r-- nkpro nkpro]  │   │   └── init.sh
#
# [drwxrwxrwt root  root ]  ├── tusr
# [drwxr-xr-x root  root ]  │   └── darling
# [-rw-r--r-- root  root ]  │       └── to_install.sh

this_file="$(readlink -f $0)"

cd /mnt/Extended/LinuxExtRoot || ( echo 'Extended partition not mounted OR No file tree found' && exit )

mkdir ./"thome/${USER}_darling"
chmod go-rwx ./"thome/${USER}_darling"

HOME="/mnt/Extended/LinuxExtRoot/thome/${USER}_darling"
cd ~/ || ( echo 'Can'"'"'t enter this new home' && exit)
echo "New home dir : $(pwd)"

sudo pacman -S --needed make cmake clang flex bison icu fuse gcc-multilib lib32-gcc-libs pkg-config fontconfig cairo libtiff python2 mesa llvm libbsd libxkbfile libxcursor libxext libxkbcommon libxrandr ffmpeg git git-lfs

mkdir darling_src_repo
cd darling_src_repo || exit
git clone --recursive https://github.com/darlinghq/darling.git

mkdir darling/build
cd darling/build || exit
cmake .. -DCMAKE_INSTALL_PREFIX=/mnt/Extended/LinuxExtRoot/tusr/darling

cat <<EOF > ~/init.sh
export HOME="/mnt/Extended/LinuxExtRoot/thome/\${USER}_darling"
export PATH="/mnt/Extended/LinuxExtRoot/tusr/darling/bin:\${PATH}"
export DPREFIX="/mnt/Extended/LinuxExtRoot/thome/${USER}_darling/.darling"
echo now : HOME="\$HOME"
echo now : PATH="\$PATH"
echo Envs: DPREFIX="\$DPREFIX"
echo "'$ darling shell' to start darling"
EOF
mkdir ~/Desktop ~/Documents ~/Downloads # Just some dirs in home

make

sudo mkdir /mnt/Extended/LinuxExtRoot/tusr/darling
sudo cp "$this_file" /mnt/Extended/LinuxExtRoot/tusr/darling/to_install.sh
sudo make install
