# @summary simple module to checkout an ansible repo to a bas dir and set the vault pass
# @param git_repo the git repo to checkout
# @param vault_pass the .ANSIBLE_VAULT_PASS
# @param copy_ansible_cfg if true copy $base_dir/ansible.cfg -> /etc/ansible/ansible.cfg
# @param ansible_user the user that will run playbooks
# @param checkout_user the user to use to checkout ansible
# @param base_dir the directory wehre we clone the repo
# @param ansible_vault_path the path to write the ANSIBLE_VAULT_PASS this should match the cfg
class ansible (
  String[1]         $git_repo,
  Sensitive[String] $vault_pass,
  Boolean           $copy_ansible_cfg   = false,
  String[1]         $ansible_user       = 'ansible',
  String[1]         $checkout_user      = $ansible_user,
  Stdlib::Unixpath  $base_dir           = '/srv/ansible',
  Stdlib::Unixpath  $ansible_vault_path = "${base_dir}/.ANSIBLE_VAULT_PASS",
) {
  ensure_packages(['ansible'])
  file { $base_dir:
    ensure => directory,
    owner  => $checkout_user,
    group  => $ansible_user,
  }
  vcsrepo { $base_dir:
    ensure   => latest,
    provider => 'git',
    revision => 'master',
    source   => $git_repo,
    user     => $checkout_user,
    require  => File[$base_dir],
  }
  file { $ansible_vault_path:
    ensure  => file,
    owner   => $ansible_user,
    content => $vault_pass.unwrap,
  }

  if $copy_ansible_cfg {
    file { '/etc/ansible':
      ensure => directory,
    }
    file { '/etc/ansible/ansible.cfg':
      ensure  => 'file',
      source  => "${base_dir}/ansible.cfg",
      require => Vcsrepo[$base_dir],
    }
  }
}
