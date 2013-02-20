vcsrepo { 'gotip':
    ensure => latest,
    path => '/usr/local/go',
    source => 'https://code.google.com/p/go',
    revision => tip,
    provider => hg
}

exec { 'buildgo':
    require => Vcsrepo ['gotip'],
    command => '/usr/local/go/src/all.bash',
    cwd => '/usr/local/go/src',
    creates => '/usr/local/go/bin/go'
}

file { 'golang.sh':
    require => Exec['buildgo'],
    ensure => present,
    path => '/etc/profile.d/golang.sh',
    source => '/root/wiki-puppet-config/templates/etc/profile.d/golang.sh',
    owner => root,
    group => root,
    mode => 0644
}   
