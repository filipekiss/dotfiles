# Ubuntu-only stuff. Abort if not Ubuntu.
! has_dotfiles_function > /dev/null 2>&1 && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
! has_dotfiles_function > /dev/null 2>&1 && echo "Something went wrong. Try again" && exit 1
is_ubuntu_desktop || return 1

[[ $+commands[youtube-dl] ]] && return 0

e_info "Installing latest version for youtube-dl"
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
e_success "${RESET}All Done"
