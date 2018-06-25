function! s:CheckColorScheme()

  let s:color_file=expand('~/.vimrc_color')
  let s:use_default=1

  if filereadable(s:color_file)
    try
      execute 'source ' . s:color_file
      let s:use_default=0
    catch
      let s:use_default=1
    endtry
  endif

  if (s:use_default > 0)
    set background=dark
    color gruvbox
  endif


  doautocmd ColorScheme
endfunction

augroup fckUpdateColorScheme
  autocmd!
  autocmd FocusGained * call s:CheckColorScheme()
augroup END

call s:CheckColorScheme()
