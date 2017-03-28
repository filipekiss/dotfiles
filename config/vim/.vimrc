" ###############################################################################
" # My Vim Configuration							#
" #										#
" # I'll try to document every option here, I Promise				#
" #										#
" # Author: Filipe Kiss <eu@filipekiss.com.br>					#
" #										#
" # Thanks to Nate Dickson and his Painless Vim book 				#
" ###############################################################################

" Rum vim as vim and not as vi.
set nocompatible

" Syntax Coloring! Hooray!
syntax on

" Show Line Numbers
set nu

" Auto-Indent and guess filetype
filetype indent plugin on

" My Color Scheme of Choice
colorscheme nord

" Highlight current line
set cursorline

" Use <F4> or <Leader>. to toggle relative line numbers
nmap <F4> :set rnu!<CR>
nmap <Leader>. <F4>

" Leader Key to comma
let mapleader=","

" Highlight Search
set hls

" Pathogen setup
execute pathogen#infect()
