# Class: r10k::webhook::package
#
#
class r10k::webhook::package (
  $package_url  = $r10k::params::package_url,
) {
  case $facts['os']['family'] {
    'RedHat': {
      $provider = 'rpm'
      $pkg_file = '/tmp/webhook-go.rpm'
    }
    'Debian', 'Ubuntu': {
      $provider = 'dpkg'
      $pkg_file = '/tmp/webhook-go.deb'
    }
    default: {
      fail("Operating system ${facts['os']['name']} not supported for packages")
    }
  }

  file { $pkg_file:
    ensure => file,
    source => $package_url,
    before => Package['webhook-go'],
  }

  package { 'webhook-go':
    ensure   => 'present',
    source   => $pkg_file,
    provider => $provider,
  }
}
