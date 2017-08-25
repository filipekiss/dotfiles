# My TMUX config

There's not much secret on the tmux config itself. It's basically my key bindings. Most, if not all
of them are commented, so you can just read them directly from the `.tmux.conf` file.

There's a `.tmux.reset.conf` that is sourced at the beginning of my `.tmux.conf` that resets the
key bindings to the defaults of TMUX (and then my own custom key bindings are applied). This is to
allow me to just `source ~/.tmux.conf` and try changed bindings. See [this question on
stackoverflow][tmux-reset-binding] for more info.

## TMUXP - TMUX Session Manager

I'm using [tmuxp][tmuxp] as my session manager. It's written in Python and installed via `pip` (it's
on my `../../scripts/python-packages.zsh` file) and it's pretty easy to use.

I currently have two tmux sessions, one for this dotfiles (which is pretty default) and one a little
more "advanced" for my workspace:

![tmux-screenshot](https://raw.githubusercontent.com/filipekiss/dotfiles/master/config/tmux/screenshot.png)

It has a custom layout, it changes the panes to their proper folders and runs a few commands as soon
as you start the session (`git status` and `ctop -a`). You can check all of this reading [the
configuration file][tmuxp-saraiva]

## Saving a custom session to a file

So, did I write the layout line by hand? Of course not.

Just create a new tmux session, divide then as you want and run, in any of the panes `tmux freeze
$(tmux display-message -p "#S")`. This will prompt you to save the session. The default path is
`$HOME/.tmuxp/<session-name>.yaml`.

Some editing might be needed, but nothing too complex. You can read [tmuxp
documentation][tmuxp-docs] to better grasp how this works

[tmux-reset-binding]: https://unix.stackexchange.com/questions/57641/reload-of-tmux-config-not-unbinding-keys-bind-key-is-cumulative
[tmuxp]: https://github.com/tony/tmuxp/
[tmuxp-saraiva]: https://github.com/filipekiss/dotfiles/blob/master/config/tmux/.tmuxp/saraiva.yaml
[tmux-docs]: http://tmuxp.git-pull.com
