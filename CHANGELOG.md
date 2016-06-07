# CHANGELOG for ssh

## 0.10.16
* #58 fix deprication warning in default value of provider (thanks to @CloCkWeRX)
* #59 - fix known_hosts diretctory creation (thanks to @atward)

## 0.10.14
* #54 fix issues in readme (Thanks to @javierav)
* #57 remove un-needed conditional (thanks to @elser82)
* several updates to get rubocop and foodcritic happy

## 0.10.12
* Updated authorized_keys to allow for commas, quotes, and spaces inside the options.
* fixed a bug that was adding a single space to the end of entries.

## 0.10.10
* Fixed default key type for authorized keys
* Added some basic validation to ssh keys in authorized_keys provider

## 0.10.8
* added matchers for authorized_keys

## 0.10.6
* add authorized_keys resource

## 0.10.5
* add support for RHEL family

## 0.10.4
* fix github #39 where we use the resource name rather than host (The name attribute) in the config LWRP

## 0.10.2
* Update the README
* Fix some spec tests
* Fix bug in `config` that did not allow `HostName` directive

## 0.10.0
* MAJOR rewrite, but no breaking changes known of.

## 0.6.5

* Add an option for the ssh port number to known_hosts (Scott Arthur)

## 0.6.4

* Use OHAI to determine the user's $HOME (Tom Duckering)

## 0.6.3:

* Fixed libary to make /root instead of /home/root work (Vincent Gijsen)
* Correct default action for config resource (joelwurtz)
* Use the correct user and path for the remove action (roderik)

## 0.6.0:

* Initial release of ssh
