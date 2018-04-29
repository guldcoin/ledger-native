# ledger-native

This directory contains a wrapper for [ledger-cli](https://ledger-cli.org)
messaging API that allows to communicate with a native application.

### Installation

In order for this program to work, you need to have python and [ledger-cli](https://ledger-cli.org) installed.

##### Windows

Run `install_host.bat` script.
This script installs the native messaging host for the current user, by
creating a registry key
`HKEY_CURRENT_USER\SOFTWARE\Google\Chrome\NativeMessagingHosts\com.guld.ledger`
and setting its default value to the full path to
`com.guld.ledger-win.json .`
If you want to install the native messaging host for all users, change HKCU to
HKLM.

##### Mac and Linux:
Run `install_host.sh` script.

By default the host is installed only for the user who runs the script, but if
you run it with admin privileges (i.e. `sudo install_host.sh`), then the
host will be installed for all users. You can later use `uninstall_host.sh`
to uninstall the host.

### Credits & License

This project is a fork of the example native-messenger from the [chomium docs](https://chromium.googlesource.com/chromium/src/+/master/chrome/common/extensions/docs/examples/api/nativeMessaging).

This original example is licensed BSD, while this fork is the closely related MIT.

