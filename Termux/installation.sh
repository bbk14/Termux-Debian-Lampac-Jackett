#!/bin/bash
RED='\033[1;31m'
GREEN='\033[1;32m'
#install packages in Termux
pkg install tmux proot-distro -y
proot-distro install debian
#download scripts in Termux
curl -s -O https://raw.githubusercontent.com/bbk14/TermuxDebian/main/Termux/note.sh
chmod 755 note.sh
curl -s -O https://raw.githubusercontent.com/bbk14/TermuxDebian/main/Termux/tmux_off.sh
chmod 755 tmux_off.sh
curl -s -O https://raw.githubusercontent.com/bbk14/TermuxDebian/main/Termux/packages.sh
chmod 755 packages.sh
curl -s -O https://raw.githubusercontent.com/bbk14/TermuxDebian/main/Termux/updater.sh
chmod 755 updater.sh
#start Debian
proot-distro login debian
#install packages in Debian
apt-get update
apt-get install -y libicu72
apt-get install -y wget
#clean packages cache Debian
apt-get clean
cd /home
mkdir updater
mkdir config
chmod 755 -R /home/updater
chmod 755 -R /home/config
#exit from Debian
exit
ln -s /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/ debian
#add scripts to autorun in Termux when it open
cat <<EOF>> pac.sh
bash note.sh
read -p ""
EOF
chmod 755 pac.sh
cat <<\EOF>> .bashrc
pkg clean
bash tmux_off.sh
bash updater.sh
tmux new-session -d -s pac bash pac.sh
tmux select-layout -t pac tiled
tmux split-window -h -p 75 -t pac:0 nano pac.sh
killall nano
bash note.sh
bash packages.sh
EOF
#clean packages cache Termux
pkg clean
#Done
echo ""
echo "#############################################"
echo -e "${GREEN}***####Done####***"
echo -e "${RED}close Termux and open it again to apply changes!"
echo -e "${GREEN}type to close: ${RED}exit${NC}"
