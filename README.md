wiki-puppet-config
==================

Puppet files to setup a system with golang, plus Smallest-Federated-Wiki

-- Assuming base system:
   * openSUSE 12.2
   * having run zypper update
   * Add puppet 3.x, plus puppetlabs-vcsrepo module
     - zypper ar http://download.opensuse.org/repositories/systemsmanagement:/puppet:/devel/openSUSE_12.2/systemsmanagement:puppet:devel.repo
     - zypper install puppet (requires choice, 1 - use 586 version of json lib)
     - puppet module install puppetlabs-vcsrepo

* Add git to get wiki-puppet-config
  - zypper install git
  - git clone https://github.com/stephen-marshall-moore/wiki-puppet-config.git

* run puppet scripts
  - puppet apply site.pp
      makes sure required packages available
  - puppet apply golang.pp
      fetches and compiles go (note: this is the tip, so tests sometimes fail
                                     and this may not be a requirement
                                     since html is now in go.net )
  - logout/login (or otherwise reset environment so GOPATH is set)
  - puppet apply wiki.pp
      ensures fedwiki user present
      gets go package prerequisites
      fetches and compiles fedwiki server
      installs wiki.service

