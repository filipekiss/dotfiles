if (( ! $+commands[youtube-dl] )); then
  return 0
fi

unalias yt2mp3 2>/dev/null

function yt2mp3() {
  if [[ $# -eq 0 ]]; then
    e_info "USAGE: yt2mp3 <youtube-url>"
    return 1
  else
    youtube-dl -t -i --extract-audio --audio-format mp3 $@
  fi
}
