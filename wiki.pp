group { gophers:
  ensure => present
}

user { fedwiki:
  ensure => present,
  managehome => true,
  gid => 'gophers',
  require => Group['gophers'],
  comment => 'fedwiki runner'
}

package { github.com/gorilla/mux:
  provider => go
}

package { github.com/gorilla/sessions:
  provider => go
}

package { code.google.com/p/go.net/html:
  provider => go
}

package { github.com/stephen-marshall.moore/openid.go/src/openid:
  provider => go
}

vcsrepo { 'smallest':
  ensure => latest,
  path => '/home/fedwiki/smallest',
  source => 'https://github.com/stephen-marshall-moore/Smallest-Federated-Wiki.git',
  revision => 'tip',
  provider => git,
  user => 'fedwiki',
  owner => 'fedwiki',
  group => 'gophers'
}

exec { 'build.wiki':
    require => Vcsrepo ['smallest'],
    command => '/usr/local/go/bin/go build -o ../../bin/server server.go pagedata.go content.go filestore.go',
    cwd => '/home/fedwiki/smallest/server/go',
    creates => '/home/fedwiki/smallest/bin/server'
}    

file { 'wiki.service':
  path => '/etc/systemd/user/wiki.service',
  ensure => present,
  owner => 'fedwiki',
  group => 'gophers',
  mode => 0644,
  source => '/root/wiki-puppet-config/templates/etc/systemd/user/wiki.service',
  require => Exec['build.wiki']
}

file { '/etc/systemd/system/wiki.service':
  ensure => link,
  target => '/etc/systemd/user/wiki.service',
  require => File['wiki.service']
}

file { '/etc/systemd/system/default.target.wants/wiki.service':
  ensure => link,
  target => '/etc/systemd/user/wiki.service',
  require => File['wiki.service']
}

service { 'wiki.service':
  enable => true,
  ensure => running,
  provider => systemd,
  require => [File['/etc/systemd/system/wiki.service'], File['/etc/systemd/system/default.target.wants/wiki.service']]
}
