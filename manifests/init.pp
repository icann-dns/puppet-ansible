# == Class: ansible
#
class ansible (
  Optional[Tea::Puppetsource] $scripts      = undef,
  Optional[Tea::Puppetsource] $modules      = undef,
  Optional[Tea::Puppetsource] $hosts_script = undef,
  Tea::Absolutepath           $config_dir   = $::ansible::params::config_dir,
  Tea::Absolutepath           $module_dir   = '/usr/share/ansible',
) inherits ansible::params {
  ensure_packages(['ansible'])
  if $modules {
    file {$module_dir:
      ensure  => directory,
      source  => $modules,
      recurse => remote,
    }
  }
  if $scripts {
    file { "${config_dir}/scripts":
      ensure  => directory,
      source  => $scripts,
      recurse => remote,
    }
  }
  if $hosts_script {
    file { "${config_dir}/hosts":
      ensure => file,
      source => $hosts_script,
      mode   => '0555',
    }
  }
}
