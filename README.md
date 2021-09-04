# vagrant-zones
Vagrant Plugin which can be used to managed Bhyve, LX and native zones on illumos (OmniOSce)

- [Status](#status)
  - [Functions](https://github.com/Makr91/vagrant-zones/wiki/Status#functions)
  - [Boxes](https://github.com/Makr91/vagrant-zones/wiki/Status#Box-Support)
- [Installation](#installation)
- [Known Issues](https://github.com/Makr91/vagrant-zones/wiki/Known-Issues-and-Workarounds)
- [Development](https://github.com/Makr91/vagrant-zones/wiki/Plugin-Development-Environment)
  - [Preparing OS environment](https://github.com/Makr91/vagrant-zones/wiki/Plugin-Development-Environment#setup-os-for-development)
  - [Setup vagrant-zones environment](https://github.com/Makr91/vagrant-zones/wiki/Plugin-Development-Environment#setup-vagrant-zones-environment)
- [Commands](https://github.com/Makr91/vagrant-zones/wiki/Commands) 
  - [Create a box](https://github.com/Makr91/vagrant-zones/wiki/Commands#create-a-box)
  - [Add the box](https://github.com/Makr91/vagrant-zones/wiki/Commands#add-the-box)
  - [Run the box](https://github.com/Makr91/vagrant-zones/wiki/Commands#run-the-box)
  - [SSH into the box](https://github.com/Makr91/vagrant-zones/wiki/Commands#ssh-into-the-box)
  - [Shutdown the box and cleanup](https://github.com/Makr91/vagrant-zones/wiki/Commands#shutdown-the-box-and-cleanup)
  - [Convert the Box](https://github.com/Makr91/vagrant-zones/wiki/Commands#convert)
  - [Detect existing VMs](https://github.com/Makr91/vagrant-zones/wiki/Commands#detect)
  - [Create, Manage, Destroy ZFS snapshots](https://github.com/Makr91/vagrant-zones/wiki/Commands#zfs-snapshots)
  - [Clone and existing zone](https://github.com/Makr91/vagrant-zones/wiki/Commands#clone)
  - [Safe restart/shutdown](https://github.com/Makr91/vagrant-zones/wiki/Commands#safe-control)
  - [Start/Stop console](https://github.com/Makr91/vagrant-zones/wiki/Commands#console)


## Installation

Publiched Package locations:
- [rubygems.org](https://rubygems.org/gems/vagrant-zones).
- [github.com](https://github.com/Makr91/vagrant-zones/packages/963217)

### Setup OS Installation

  * ooce/library/libarchive
  * system/bhyve
  * system/bhyve/firmware
  * ooce/application/vagrant
  * ruby-26
  * zadm

### Setup vagrant-zones

 To install it in a standard vagrant environment:
 
 `vagrant plugin install vagrant-zones`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Makr91/vagrant-zones.


## License

This project is licensed under the AGPL v3 License - see the [LICENSE](LICENSE) file for details

## Built With
* [Vagrant](https://www.vagrantup.com/) - Portable Development Environment Suite.
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) - Hypervisor.
* [zadm](https://github.com/omniosorg/zadm)

## Contributing Sources
* [vagrant-bhyve](https://github.com/jesa7955/vagrant-bhyve) - A Vagrant plugin for FreeBSD to spin up Bhyve Guests.
* [vagrant-zone](https://github.com/skylime/vagrant-zone) - A Vagrant plugin to spin up LXZones.


## Contributing

Please read [CONTRIBUTING.md](https://www.prominic.net) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors
* **Thomas Merkel** - *Initial work* - [Skylime](https://github.com/skylime)
* **Mark Gilbert** - *Takeover* - [Makr91](https://github.com/Makr91)

See also the list of [contributors](https://github.com/Makr91/vagrant-zones/graphs/contributors) who participated in this project.

## Acknowledgments

* Hat tip to anyone whose code was used
