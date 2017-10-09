# .dotfiles

![screenshot](https://raw.githubusercontent.com/filipekiss/dotfiles/master/screenshot.gif)

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

If it is the first time you're running this on the machine (or if you want to check for
updates/installation changes), run `./bin/dotfiles install`


## Private Keybase Submodule

Keybase has [private encrypted git repos][keybase-git-announcement], so my private data are hosted
there. After the first installation, just run `make keybase` and it will ask you to login on keybase
if it's not logged yet and then will clone the sub repository. After that, just run `make stow`
again.

## Sensitive Data

Any sensitive file (such as `.ssh/id_rsa`) is encrypted using a `aes-256-cbc` cypher and protected
with a password. `brew` installed `transcrypt`, so all you need to do is run `transcrypt -c
aes-256-cbc -p <PASSWORD>` to make these files unencrypted on this machine.

To mark a file as sensitive and ensure it's encrypted when pushed elsewhere, all you need to do is
add it to `.gitattributes`. You can run `echo "filename filter=crypt diff=crypt" | tee -a
.gitattributes` to add the file. I may write a `git-crypt` binary or something like it someday.

## GPG Key

Since I use `keybase` and it's installed via `brew`, just run the command below. (How you'll login
to keybase is your own problem :P)

```
keybase pgp export --secret | gpg --allow-secret-key-import --import
```

Don't forget to trust said keys.

I may add the gpg to the repository someday, but, for now, keybase is the way to go.

