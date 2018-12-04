# .dotfiles

![screenshot]

![GitHub release](https://img.shields.io/github/release/filipekiss/dotfiles.svg?colorA=D3869B&colorB=8F3F71&style=flat-square)
![Github commits (since latest release)](https://img.shields.io/github/commits-since/filipekiss/dotfiles/latest.svg?colorA=D3869B&colorB=8F3F71&style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/filipekiss/dotfiles.svg?colorA=D3869B&colorB=8F3F71&style=flat-square)
![Github Commits Last Year](https://img.shields.io/github/commit-activity/y/filipekiss/dotfiles.svg?colorA=D3869B&colorB=8F3F71&style=flat-square)

# What's in the box?

-   [Homebrew]
-   [tmux]
-   [VimFiles] - [NeoVim] with Node, Python and Ruby Support ([Vim] 8.0 or later
    also supported with Python and Ruby)
-   [nvr]
-   [Git]
-   [ZDOTDIR][zshfiles] - [Zsh] with [Syntax Highlight], [Tab Completion],
    [Substring Search]…

The config files are managed using [zshero]

# Requirements

-   [zsh]

`zsh` comes default on macOS, but you may need to install it if you're in a
Linux box.

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

```sh
keybase pgp export --secret | gpg --allow-secret-key-import --import
gpg --edit-key <you@email.com>
```

Get the long key ID:

```sh
gpg --list-secret-keys --keyid-format LONG <you@email.com>
```

The string you need will be something like 'rsa4096/<LONG KEY HERE>' (You don't
need anything from the slash backwards)

Add to your LOCAL `.gitconfig` file:

```sh
git config -f ~/.gitconfig.local user.signingkey <LONG KEY>
```

Don't forget to trust said keys.

## Authors

[Filipe Kiss]

[screenshot]:
    https://raw.githubusercontent.com/filipekiss/dotfiles/master/screenshot.png
[homebrew]: https://brew.sh/
[tmux]: http://tmux.sourceforge.net/
[neovim]: https://neovim.io/
[vim]: http://www.vim.org/
[git]: http://git-scm.com/
[zsh]: http://www.zsh.org/
[nvr]: https://github.com/mhinz/neovim-remote
[syntax highlight]: https://github.com/zdharma/fast-syntax-highlighting
[tab completion]: https://github.com/zsh-users/zsh-completions
[substring search]: https://github.com/zsh-users/zsh-history-substring-search
[zshero]: https://github.com/filipekiss/zshero
[filipe kiss]: https://twitter.com/filipekiss
[vimfiles]: https://github.com/filipekiss/vimfiles
[zshfiles]: https://github.com/filipekiss/zdotdir
