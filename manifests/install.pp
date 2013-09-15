# == Class: unarchiver::install
#
# Installs The Unarchiver for OS X.
#
# === Authors
#
# Ryan Skoblenick <ryan@skoblenick.com>
#
# === Copyright
#
# Copyright 2013 Ryan Skoblenick.
#
class unarchiver::install {
  $version = $unarchiver::version

  case $::kernel {
    'Darwin': {
       $source = "https://theunarchiver.googlecode.com/files/TheUnarchiver${version}.zip"
    }
    default: {
      fail("Unsupported Kernel: ${::kernel} operatingsystem: ${::operatingsystem}")
    }
  }

  Exec {
    cwd => '/tmp',
    path => '/usr/bin:/bin',
    onlyif => "test ! -f /var/db/.puppet_appzip_installed_unarchiver-${version}",
  }

  exec {'unarchiver-download':
    command => "curl -o TheUnarchiver.zip -C - -k -L -s --url ${source}",
  }
  ->
  exec {'unarchiver-install':
    command => "unzip -o TheUnarchiver.zip -d /Applications",
  }
  ->
  file {"/var/db/.puppet_appzip_installed_unarchiver-${version}":
    ensure => file,
    content => "name:'unarchiver'\nsource:'${source}'",
    owner => 'root',
    group => 'wheel',
    mode => '0644',
  }
  ->
  file {'/tmp/TheUnarchiver.zip':
    ensure => absent,
  }
}