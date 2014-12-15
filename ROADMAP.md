v0.10.0
===========

* Make everything idempotent
* Chefspec for everything that can
* Kitchen for anything we can't chefspec (hopefully that's nothing)
* use_inline_resources
* support why_run
* Merge any outstanding PR's I'm comfortable with
* Add CONTRIBUTING.md

v0.10.1
==========
* add foodcritic support

v1.0
=========
* Switch to MWRP using poise
* Rename some actions and attributes
  * known_hosts.key becomes known_hosts.entry
THIS WILL BREAK stuff

Eventually (PRs are VERY welcome)
===========
* Add a authorized_keys resource
* Get guardfile figured out
* The order of entries in ssh_config matters.  So we need to support a priority or something to set it with.