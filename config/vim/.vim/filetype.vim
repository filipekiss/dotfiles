" Setting filetypes with high prio, see |new-filetype|

augroup filetypedetect
  au! BufRead,BufNewFile .{babel,eslint,stylelint,jshint}*rc,\.tern-*,*.json setl filetype=json
  au! BufRead,BufNewFile {Gemfile,Brewfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,config.ru,*.rake} setl filetype=ruby
  au! BufNewFile,BufRead .tags setl filetype=tags
  au! BufRead,BufNewFile jrnl*.txt,TODO setl filetype=markdown
  au! BufRead,BufNewFile *zsh/* setl filetype=zsh
  au! BufNewFile,BufRead *.twig set ft=jinja2
augroup END
