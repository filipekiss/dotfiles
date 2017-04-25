# Ubuntu-only stuff. Abort if not Ubuntu.
! has_dotfiles_function > /dev/null 2>&1 && [[ -e $HOME/.dotfiles/bin/dotfiles ]] && source $HOME/.dotfiles/bin/dotfiles "source"
! has_dotfiles_function > /dev/null 2>&1 && echo "Something went wrong. Try again" && exit 1
is_ubuntu_desktop || return 1

[[ $+commands[ctags] ]] && return 0

CTAGS_REPO="https://github.com/universal-ctags/ctags.git"

e_info "Cloning Universal Ctags"
cd /tmp
e_info $PWD
git clone $CTAGS_REPO ctags
cd ctags
e_info "Configuring"
./autogen.sh
./configure
sudo make
e_info "Installing"
sudo make install
