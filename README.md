# .dotfiles

![screenshot]

# Requirements

 * zsh

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

## Private Keybase Submodule

Keybase has [private encrypted git repos], so my private data is hosted
there. After the first installation, just run `make keybase` and it will ask you to login on keybase
if it's not logged yet and then will clone the sub repository. After that, just run `make stow`
again.

## GPG Key

Since I use `keybase` and it's installed via `brew`, just run the command below. (How you'll login
to keybase is your own problem :P)

```
keybase pgp export --secret | gpg --allow-secret-key-import --import
gpg --edit-key <you@email.com>
```

Don't forget to trust said keys.

I may add the gpg to the repository someday, but, for now, keybase is the way to go.

[private encrypted git repos]: https://keybase.io/blog/encrypted-git-for-everyone
[screenshot]: https://raw.githubusercontent.com/filipekiss/dotfiles/master/screenshot.gif
