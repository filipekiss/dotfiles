# ZSH Highlight petterns for interactive shell.
# The syntax for values is the same as the syntax of "types of highlighting" of
# the zsh builtin $zle_highlight array, which is documented in the zshzle(1)
# manual page. http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
#
# +TODO: Find out how to make custom highlighters work with zdharma/fast-highlight

# Commands that start with `rm -rf` will be printed in red
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
