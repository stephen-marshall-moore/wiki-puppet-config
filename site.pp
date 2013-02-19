package { 'mercurial':
    ensure => installed,
    provider => zypper
}

package { 'git':
    ensure => installed,
    provider => zypper
}

package { 'gcc':
    ensure => installed,
    provider => zypper
}

package { 'tar':
    ensure => installed,
    provider => zypper
}

package { 'wget':
    ensure => installed,
    provider => zypper
}

