# Ubuntu-only stuff. Abort if not Ubuntu.
! has_dotfiles_function > /dev/null 2>&1 && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
! has_dotfiles_function > /dev/null 2>&1 && echo "Something went wrong. Try again" && exit 1
is_ubuntu_desktop || return 1

[[ -e /usr/share/robomongo/ ]] && return 0

e_info "Downloading RoboMongo"
cd /tmp
wget -O - https://download.robomongo.org/1.0.0-rc1/linux/robomongo-1.0.0-rc1-linux-x86_64-496f5c2.tar.gz > robomongo.tar.gz
wget -O - https://robomongo.org/static/robomongo-1024x1024-bfaf4052.png > icon.png

sudo mkdir /usr/share/robomongo
sudo chmod +x /usr/share/robomongo

e_info "Extracting files..."

tar -xvf robomongo.tar.gz
cd ./robomongo-*

e_info "Copying new files..."
sudo cp -r * /usr/share/robomongo
user=$(whoami)
sudo chown -R $user:$user /usr/share/robomongo/.

e_info "Making desktop files..."

cd /tmp

sudo echo "[Desktop Entry]" > robomongo.desktop
sudo echo "Name=RoboMongo" >> robomongo.desktop
sudo echo "GenericName=" >> robomongo.desktop
sudo echo "Comment=" >> robomongo.desktop
sudo echo "Exec=/usr/share/robomongo/bin/robomongo" >> robomongo.desktop
sudo echo "Terminal=false" >> robomongo.desktop
sudo echo "Type=Application" >> robomongo.desktop
sudo echo "Icon=/usr/share/robomongo/icon.png" >> robomongo.desktop
sudo echo "Categories=" >> robomongo.desktop
sudo echo "StartupNotify=false" >> robomongo.desktop

sudo cp icon.png /usr/share/robomongo/icon.png
sudo cp robomongo.desktop /usr/share/applications/robomongo.desktop

e_info "Removing old files..."

rm /tmp/robomongo.tar.gz
rm /tmp/icon.png
rm /tmp/robomongo.desktop
rm -R /tmp/robomongo*


e_success "${RESET}Installation Complete!"
