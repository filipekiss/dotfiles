# Don't run if youtube-dl is not available
(( $+commands[youtube-dl] )) || return 0

unalias yt2mp3 2>/dev/null

function yt2mp3() {
  if [[ $# -eq 0 ]]; then
    e_info "USAGE: yt2mp3 <youtube-url>"
    return 1
  else
    youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" --restrict-filenames $@
  fi
}

# Complete as if using youtube-dl directly
compdef '_youtube-dl' yt2mp3
