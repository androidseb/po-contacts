# PO Contacts

PO Contacts stands for "Privacy Oriented Contacts".

The vision and end goal of this project is to have a **portable** and **privacy oriented** contacts manager.

* Portable means you can use it on "any" platform (see [supported platforms](#supported-platforms)).

* Privacy oriented means it's built with a "privacy first" mindset. See the [privacy policy](./privacy_policy) for details.

## Disclaimer

I built this app on my free time and mostly as a learning experience. I intend to use it myself and I'm happy to share it publicly for free if it can help others. That being said, if you choose to use it, you use it at your own risks, there is no warranty (see the [licence](./LICENSE) for more details).

## Supported Platforms

* Android: all features
* iOS: all features
* Linux: all features
* MacOS: coming soon
* Windows: coming soon

## How to install

* Android: choose the option that suits you best:
  * [Google Play Store](https://play.google.com/store/apps/details?id=com.exlyo.pocontacts)
  * [APK file](#todo)
* iOS: [App Store](https://apps.apple.com/us/app/po-contacts/id1495556759)
* Linux: choose the option that suits you best:
  * [zip archive](#todo)
  * [deb archive](#todo)

For more download options like older versions download, see the [releases download page](#todo).

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

## Credits

* The [flutter project](https://flutter.dev/) for all the development tools.
* The [textmate](https://github.com/textmate/textmate/blob/master/Applications/TextMate/resources/Info.plist) source code helped me figure out how to specify vcard files in an iOS app Info.plist.
