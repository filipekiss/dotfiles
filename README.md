# .dotfiles (legacy)

> These are my old dotfiles. I've kept them here so I (or you) can consult them
whenever I please, but these configuration files won't be updated anymore.

![screenshot]

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

`keybase pgp pull-private`

Follow the instructions on screen

### Manually

Assuming your private key is in a file named `my_private_key.pgp`

```sh
cat my_private_key.pgp | gpg --allow-secret-key-import --import
gpg --edit-key <you@email.com>
```

Select your key (type the number and press enter) and `trust`

### Configuring Git to use the key

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
