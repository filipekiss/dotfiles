# .dotfiles

![screenshot]

# What's in the box?

 * [Homebrew] (or [Linuxbrew]) for managing [dependencies]
 * [tmux]
 * [NeoVim] with Node, Python and Ruby Support ([Vim] 8.0 or later also supported with Python and
   Ruby)
 * [Git]
 * [Zsh]
 * [A] [handful] [of] [utilities]

# Requirements

 * [zsh]

`zsh` comes default on macOS, but you may need to install it if you're in a Linux box.

## Installation

```sh
$ wget -qO- https://raw.githubusercontent.com/filipekiss/dotfiles/master/bin/dotfiles | zsh
```

```sh
$ curl -fsSL  https://raw.githubusercontent.com/filipekiss/dotfiles/master/bin/dotfiles | zsh
```

```sh
$ git clone https://github.com/filipekiss/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./bin/dotfiles
```

## GPG Key

Exported from `keybase`:

```
keybase pgp export --secret | gpg --allow-secret-key-import --import
gpg --edit-key <you@email.com>
```

Don't forget to trust said keys.

[screenshot]: https://raw.githubusercontent.com/filipekiss/dotfiles/master/screenshot.png
[Homebrew]: https://brew.sh/
[Linuxbrew]: https://linuxbrew.sh
[dependencies]: https://github.com/filipekiss/dotfiles/tree/master/homebrew
[tmux]: http://tmux.sourceforge.net/
[NeoVim]: https://neovim.io/
[Vim]: http://www.vim.org/
[Git]: http://git-scm.com/
[Zsh]: http://www.zsh.org/
[A]: https://github.com/filipekiss/dotfiles/blob/master/bin/mx
[handful]: https://github.com/filipekiss/dotfiles/blob/master/bin/extract
[of]: https://github.com/filipekiss/dotfiles/blob/master/source/functions/g.zsh
[utilities]: https://github.com/filipekiss/dotfiles/blob/master/source/functions/afk.zsh
