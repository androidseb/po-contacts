# PO Contacts

PO Contacts stands for "Privacy Oriented Contacts".

The vision and end goal of this project is to have a **portable** and **privacy oriented** contacts manager.

* Portable means you can use it on "any" platform (see [supported platforms](#supported-platforms)).

* Privacy oriented means it's built with a "privacy first" mindset. See the [privacy policy](https://www.pocontacts.app/privacy) for details.

## Disclaimer

I built this app on my free time and mostly as a learning experience. I intend to use it myself and I'm happy to share it publicly for free if it can help others. That being said, if you choose to use it, you use it at your own risks, there is no warranty (see the [licence](./LICENSE) for more details).

## Supported Platforms

* Android
* iOS
* Linux
* MacOS
* Windows

## How to install and launch

### Android

#### Install from Play Store (recommended)

* Download the app from the [Google Play Store](https://play.google.com/store/apps/details?id=com.exlyo.pocontacts)
* Start the installed app on your device

#### Install from APK file directly (advanced users)

* Download the [APK file](https://github.com/androidseb/po-contacts/releases/download/v1.1/pocontacts_android_1.1.0.apk)
* (Optional) Use your favorite search engine to figure out how to install the app from the APK file on your device
* Install the APK file on your device
* Start the installed app on your device

### iOS

* Download the app from the [App Store](https://apps.apple.com/us/app/po-contacts/id1495556759)
* Start the installed app on your device

### Linux

#### Install from ZIP archive

* Download the [zip archive](https://github.com/androidseb/po-contacts/releases/download/v1.1/pocontacts_linux_1.1.0.zip)
* Start the app by executing the `nw` file inside the main folder

#### Install from deb package

* Download the [deb package](https://github.com/androidseb/po-contacts/releases/download/v1.1/pocontacts_linux_1.1.0.deb)
* Install the deb package with the command `sudo dpkg -i package_name.deb` where `package_name.deb` is the deb package file
* Launch the app with either the `pocontacts` command or by launching the `PO Contacts` app in your applications

### Mac OS

* Download the [zip archive](https://github.com/androidseb/po-contacts/releases/download/v1.1/pocontacts_macos_1.1.0.zip)
* Double click on the zip archive from Finder
* Wait for the app to be extracted
* Place the extracted application in your applications folder (Optional)
* Double click on the extracted application to start it

### Windows

* Download the [zip archive](https://github.com/androidseb/po-contacts/releases/download/v1.1/pocontacts_windows_1.1.0.zip)
* Extract the zip archive
* Launch the "nw.exe" file from the extracted folder

For more download options like older versions download, see the [releases download page](https://github.com/androidseb/po-contacts/releases).

## Troubleshooting

### Linux Debian - Missing libatomic library

If you get this error when trying to start PO Contacts:
```
error while loading shared libraries: libatomic.so.1: cannot open shared object file: No such file or directory
```
You can most likely fix it by installing libatomic with this command:
```
sudo apt-get install libatomic1
```

## About password-based encryption

The password-based encryption uses the [Pointy Castle Library](https://pub.dev/packages/pointycastle) to:
* derive the user-inputted password with SHA-256
* encrypt the data with AES-CBC

You can look at the code to see exactly how it's implemented, but at a high level, here is how the password-based encryption works:
* generate a random one time use `salt` to add to the user-inputted password
* derive the salted user-inputted password with multiple iterations of SHA-256, producing the `encryption key`
* generate a random one time use initialization vector, also known as `IV`
* encrypt the data with AES-CBC using the `IV` and the `encryption key`
* write the resulting encrypted file in 4 distinct blocks
  * A plain text header specific to PO Contacts indicating that the content is encrypted (a few Bytes)
  * The 16 bytes long unencrypted `IV`
  * The 64 bytes long unencrypted `salt`
  * The encrypted data itself

## Credits

* The [flutter project](https://flutter.dev/) for all the development tools.
* The [textmate](https://github.com/textmate/textmate/blob/master/Applications/TextMate/resources/Info.plist) source code helped me figure out how to specify vcard files in an iOS app Info.plist.
* [NWJS](https://nwjs.io/) for the easy web app packaging tools.
* stevenroose, the author of the [Pointy Castle Library](https://pub.dev/packages/pointycastle).
* [unsplash.com](https://unsplash.com/s/photos/human-face-smile) for the free showcase contacts photos
* [theapplaunchpad.com](https://theapplaunchpad.com) for the landing page phone screen image generator
* Lulu for designing the app landing page <3
