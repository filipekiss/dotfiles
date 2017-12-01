#!/usr/bin/env zsh


weather() {
    curl -H "Accept-Language: ${LANG%_*}" wttr.in/${1:"Sao-Paulo"}
}


