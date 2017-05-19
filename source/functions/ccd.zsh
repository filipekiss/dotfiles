# Setup ccd function
# ------------------
unalias ccd 2> /dev/null
ccd() {
   local dest_dir=$(cdscuts_glob_echo | fzf )
   if [[ $dest_dir != '' ]]; then
     dest_dir=${dest_dir:s/~/$HOME}
      cd "${dest_dir%% *}"
   fi
}

ccd-add () {
  [[ ! -f ~/.ccdpaths ]] && touch ~/.ccdpaths
  if ! grep -Fq "${PWD}" ~/.ccdpaths; then
    echo "${PWD} # $*" | tee -a ~/.ccdpaths
  else
    grep --color=never ${PWD} ~/.ccdpaths
  fi
}
