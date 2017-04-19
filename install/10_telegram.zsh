# Ubuntu-only stuff. Abort if not Ubuntu.
! has_dotfiles_function > /dev/null 2>&1 && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
! has_dotfiles_function > /dev/null 2>&1 && echo "Something went wrong. Try again" && exit 1
is_ubuntu_desktop || return 1

[[ -e /usr/share/telegram ]] && return 1

e_info "Downloading Telegram Client"
cd /tmp
wget -O - https://tdesktop.com/linux > tsetup.tar.gz
wget -O - https://raw.githubusercontent.com/telegramdesktop/tdesktop/master/Telegram/Telegram/Images.xcassets/Icon.iconset/icon_256x256@2x.png > icon.png

sudo mkdir /usr/share/telegram
sudo chmod +x /usr/share/telegram

e_info "Extracting files..."

tar -xvJf tsetup.tar.gz
cd ./Telegram

e_info "Copying new files..."
sudo cp ./Updater /usr/share/telegram/Updater
sudo cp ./Telegram /usr/share/telegram/Telegram
user=$(whoami)
sudo chown -R $user:$user /usr/share/telegram/.

e_info "Making desktop files..."

cd /tmp

sudo echo "[Desktop Entry]" > telegram.desktop
sudo echo "Name=Telegram" >> telegram.desktop
sudo echo "GenericName=Chat" >> telegram.desktop
sudo echo "Comment=Chat with yours friends" >> telegram.desktop
sudo echo "Exec=/usr/share/telegram/Telegram" >> telegram.desktop
sudo echo "Terminal=false" >> telegram.desktop
sudo echo "Type=Application" >> telegram.desktop
sudo echo "Icon=/usr/share/telegram/icon.png" >> telegram.desktop
sudo echo "Categories=Network;Chat;" >> telegram.desktop
sudo echo "StartupNotify=false" >> telegram.desktop

sudo cp icon.png /usr/share/telegram/icon.png
sudo cp telegram.desktop /usr/share/applications/telegram.desktop

e_info "Removing old files..."

rm /tmp/tsetup.tar.gz
rm /tmp/icon.png
rm /tmp/telegram.desktop
rm -R /tmp/Telegram


e_success "${RESET}Installation Complete!"
