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

exec { 'mux':
  cwd => '/home/fedwiki',
  command => '/usr/local/go/bin/go get github.com/gorilla/mux',
  creates => '/user/local/share/go/src/github.com/gorilla/mux'
}

exec { 'sessions':
  cwd => '/home/fedwiki',
  command => '/usr/local/go/bin/go get github.com/gorilla/sessions',
  creates => '/usr/local/share/go/src/github.com/gorilla/sessions'
}

exec { 'html':
  cwd => '/home/fedwiki',
  command => '/usr/local/go/bin/go get code.google.com/p/go.net/html',
  creates => '/usr/local/share/go/src/code.google.com/p/go.net/html'
}

exec { 'openid':
  cwd => '/home/fedwiki',
  command => '/usr/local/go/bin/go get github.com/stephen-marshall-moore/openid.go/src/openid',
  creates => '/usr/local/share/go/github.com/src/stephen-marshall-moore/openid.go/src/openid'
}

vcsrepo { 'smallest':
  ensure => latest,
  path => '/home/fedwiki/smallest',
  source => 'https://github.com/stephen-marshall-moore/Smallest-Federated-Wiki.git',
  revision => 'gomerge',
  provider => git,
#  user => 'fedwiki',
  owner => 'fedwiki',
  group => 'gophers'
}

exec { 'build.wiki':
    require => [ Vcsrepo ['smallest'], Exec ['mux'], Exec ['sessions'], Exec ['html'], Exec ['openid'] ],
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
