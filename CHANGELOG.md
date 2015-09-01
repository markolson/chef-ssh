# CHANGELOG for ssh
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
