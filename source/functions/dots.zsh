# --------------------------------------------------------------------------------------------------
# dots function
# --------------------------------------------------------------------------------------------------
#
# Description
# --------------------------------------------------------------------------------------------------
# A simple wrapper function to jump to ~/.dotfiles
# --------------------------------------------------------------------------------------------------
#
# Authors
# -------
# Filipe Kiss <eu@filipekiss.com.br> http://github.com/filipekiss
# --------------------------------------------------------------------------------------------------
#
# Usage
# -----
# Just call `dots` from the command line. If you're on tmux and a dotfiles session already exists,
# just switch to that session. If you're in tmux and the session does not exists, create the
# session. If you're outside tmux, just cd to dotfiles dir
# --------------------------------------------------------------------------------------------------
#
# License
# -------
# The MIT License (MIT)
#
# Copyright (c) Y
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# --------------------------------------------------------------------------------------------------

function dots() {
    # If inside tmux
    if [[ $TMUX == *"tmux"* ]]; then
        (( $+commands[mx] )) && $commands[mx] dotfiles && return 0
        (( $(tmux has-session -t "dotfiles" > /dev/null 2>&1) )) && tmux attach -t dotfiles && return
    fi
    [[ -n $DOTFILES && -d $DOTFILES ]] && cd $DOTFILES || cd ~/.dotfiles
}

