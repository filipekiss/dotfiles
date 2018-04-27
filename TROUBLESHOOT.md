# Troubleshooting stuff

### macOS Icons not working

If some (or all) of the macOS Icons are the "Generic Application" icon, run the commands below:

```sh
sudo find /private/var/folders/ -name com.apple.dock.iconcache -exec rm {} \;
sudo find /private/var/folders/ -name com.apple.iconservices -exec rm -rf {} \;
killall Dock
```

### NVM prefix shenanigans

So I've moved from pure node to NVM when version 10.0 dropped and I came across an issue regarding `npm config get prefix` that would make NVM not work properly. This should happen when things are installed in a new system, but
either way, check if you have `npm` or `npx` in your path that might be causing trouble with the prefix setting.
Remove than and you should be good to go. You can see [this issue comment][nvm-prefix-issue] for more info.

[nvm-prefix-issue]: https://github.com/creationix/nvm/issues/1647#issuecomment-340675584
