[![Build Status](https://travis-ci.org/icann-ansible/puppet-ansible.svg?branch=master)](https://travis-ci.org/icann-ansible/puppet-ansible)
[![Puppet Forge](https://img.shields.io/puppetforge/v/icann/ansible.svg?maxAge=2592000)](https://forge.puppet.com/icann/ansible)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/icann/ansible.svg?maxAge=2592000)](https://forge.puppet.com/icann/ansible)
# ansible

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with ansible](#setup)
    * [What ansible affects](#what-ansible-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ansible](#beginning-with-ansible)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Manage client and server](#manage-client-and-server)
    * [Ansible client](#ansible-client)
    * [Ansible Server](#ansible-server)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs ansible and can also manage the custom scripts, host script and custom modules directories

## Setup

### What ansible affects

* installs ansible 
* $conf_dir/scripts
* $conf_dir/hosts
* manages /usr/share/ansible

### Setup Requirements **OPTIONAL**

* puppetlabs-stdlib 4.12.0
* icann-tea 0.2.4

### Beginning with ansible

just add the ansible class

```puppet
class {'::ansible' }
```

## Usage

### Add custom modules and scripts

You can pass URI's which will be handed to puppet and passed to a file type source parameter.

```puppet
class {'::ansible' 
  hosts_script => 'puppet:///modules/submodule/my_ansible_scripts,
  scripts => 'puppet:///modules/submodule/my_ansible_scripts,
  modules => 'puppet:///modules/submodule/my_ansible_modules,
}
```

of with hiera

```yaml
ansible::hosts_script: 'puppet:///modules/submodule/my_ansible_scripts,
ansible::scripts: 'puppet:///modules/submodule/my_ansible_scripts,
ansible::modules: 'puppet:///modules/submodule/my_ansible_modules,
```

## Reference

### Classes

#### Public Classes

* [`ansible`](#class-ansible)

#### Private Classes

* [`ansible::params`](#class-ansibleparams)

#### Class: `ansible`

Main class, includes all other classes

##### Parameters 

* `scripts (Tea::Puppetsource, Default: undef)`: This is a string which will be passed the file type source paramter and treated as a directory source and copied with recurse => remove, into the scripts dir
* `modules (Tea::Puppetsource, Default: undef)`: This is a string which will be passed the file type source paramter and treated as a directory source and copied with recurse => remove into the ansible modules dir
* `host_scripts (Tea::Puppetsource, Default: undef)`: This is a string which will be passed the file type source paramter and treted as a file source for the hosts script/inventory file
* `config_dir (Tea::Absolutepath, Default: os specific)`: Location of the config directory
* `module_dir (Tea::Absolutepath, Default: os specific)`: Location of the module directory

## Limitations

This module is tested on Ubuntu 12.04, and 14.04 and FreeBSD 10 

