# This will read the location of this file, that should be right next
# to ${ZSHRCD:-zshrc.d}.
# This will always point to the source file and not the symlink location
_zshenv_location="${${(%):-%N}:A:h}"
ZDOTDIR="${_zshenv_location}/${ZSHRCD:-zshrc.d}"
