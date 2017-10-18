# My TMUX config

There's not much secret on the tmux config itself. It's basically my key bindings. Most, if not all
of them are commented, so you can just read them directly from the `.tmux.conf` file.

# `mx` what?

I used to use [tmuxp] for managing my sessions, but I found [mx] to better suit how I work.

`mx` is a simple binary that will take one to two arguments and will create a tmux session that's
context aware. So, for example, I `cd ~/work` and run `mx`. If there's a session name `work` on
tmux, tmux will attach to that session (or switch to it if it's already running).

[My `mx` binary][mx] is slightly customized. If you `mx work` and you have a folder that is located at
either of the locations below, `mx` will load your workplace based on that location:

 - `$HOME/work`
 - `$PROJECTS/work`

You can also have something along the lines of `$PROJECTS/username/awesome` for example, than you
can just `mx username awesome` and `mx` will do it's job.

[tmuxp]: https://github.com/tony/tmuxp
[mx]: https://github.com/filipekiss/dotfiles/blob/master/bin/mx
