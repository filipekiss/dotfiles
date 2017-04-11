# Ubuntu-only stuff. Abort if not Ubuntu.
! has_dotfiles_function > /dev/null 2>&1 && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
! has_dotfiles_function > /dev/null 2>&1 && echo "Something went wrong. Try again" && exit 1
is_ubuntu || return 1

e_header "Flatabulous Theme"
e_info "Adding PPA"
sudo add-apt-repository ppa:noobslab/themes
sudo add-apt-repository ppa:noobslab/icons
e_info "Updating apt"
sudo apt-get update
e_info "Installing Flatabulous"
sudo apt-get install flatabulous-theme
e_success "${RESET}Flatabulous installed"
e_info "Installing Ultra Flat Icons"
sudo apt-get install ultra-flat-icons
e_success "${RESET}Ultra Flat installed"
