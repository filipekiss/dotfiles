function theme() {
  VIMSPECTR="$HOME/.vimspectr-shell"
  VSRC="$HOME/.vsrc"
  if [[ ! -d "${VIMSPECTR}" ]]; then
    echo "VimSpectr is not installed. Aborting…"
    return 0
  fi
  [[ -f "$VSRC" ]] && source $VSRC
  local theme_name="$1"
  [[ -z "$theme_name" && "$vsrc_current_theme" ]] && echo "Current Theme: $vsrc_current_theme" && return 0
  [[ -z "$theme_name" ]] && echo "You need to pass a theme name" && return 1
  if [[ "$theme_name" == "-" && -n "$vsrc_current_theme" && -n "$vsrc_old_theme" ]]; then
    theme_name="$vsrc_old_theme"
  fi
  if [[ -f "$VIMSPECTR/$theme_name" ]]; then
	echo "if !exists('g:colors_name') || g:colors_name != '$theme_name'" | tee ~/.vimrc_color > /dev/null
	echo "    colorscheme $theme_name" | tee -a ~/.vimrc_color > /dev/null
	echo "endif" | tee -a ~/.vimrc_color > /dev/null
	sh "$VIMSPECTR/$theme_name"
	echo "vsrc_current_theme=$theme_name" | tee ~/.vsrc > /dev/null
	if [[ -n "$vsrc_current_theme" ]]; then
	  echo "vsrc_old_theme=$vsrc_current_theme" | tee -a ~/.vsrc > /dev/null
	fi
  else
    echo "Theme $theme_name not found."
  fi
}