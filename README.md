wiki-puppet-config
==================

Puppet files to setup a system with golang, plus Smallest-Federated-Wiki


-- Alpha stage steps --

* Add git to get wiki-puppet-config
  - zypper install git
  - git clone https://github.com/stephen-marshall-moore/wiki-puppet-config.git

* Add puppet 3.x, plus puppetlabs-vcsrepo module
  - zypper ar http://download.opensuse.org/repositories/systemsmanagement:/puppet:/devel/openSUSE_12.2/systemsmanagement:puppet:devel.repo
  - zypper install puppet (requires choice, 1 - use 586 version of json lib)
  - puppet module install puppetlabs-vcsrepo

* run puppet scripts
  - puppet apply site.pp
      makes sure required packages available
  - puppet apply golang.pp
      fetches and compiles go
  - puppet apply wiki.pp
      fetches and compiles fedwiki server

-- image: base suse 12.2 updated plus mercurial and puppet 3

  - zypper update
    trust always

  - zypper install git

  - zypper ar http://download.opensuse.org/repositories/systemsmanagement:/puppet:/devel/openSUSE_12.2/systemsmanagement:puppet:devel.repo

  - zypper install puppet
    trust always

  - zypper update
    nothing to do

-- image: base suse 12.2 fedwiki
  
  - puppet apply site.pp
    (supplies tar and wget to puppet module)

  - puppet module install puppetlabs-vcsrepo

  - puppet apply golang.pp
    (usually errors on tests)

  - puppet apply wiki.pp
    (context/user is not as expected vcsrepo fails)

  - as fedwiki
    go get github.com/gorilla/mux
    go get github.com/gorilla/sessions
    go get code.google.com/p/go.net/html
    go get github.com/stephen-marshall.moore/openid.go/src/openid

  ? finish wiki.pp


