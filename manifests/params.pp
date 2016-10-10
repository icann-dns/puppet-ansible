# ansible::params
#
class ansible::params {

  case $::operatingsystem {
    'FreeBSD': {
      $config_dir = '/usr/local/etc/ansible'
    }
    default: {
      $config_dir = '/etc/ansible'
    }
  }
}
