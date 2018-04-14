# Troubleshooting stuff

### macOS Icons not working

If some (or all) of the macOS Icons are the "Generic Application" icon, run the commands below:

```sh
sudo find /private/var/folders/ -name com.apple.dock.iconcache -exec rm {} \;
sudo find /private/var/folders/ -name com.apple.iconservices -exec rm -rf {} \;
killall Dock
```
