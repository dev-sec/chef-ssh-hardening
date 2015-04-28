# Changelog

## 1.1.0

* feature: UsePrivilegeSeparation = sandbox for ssh >= 5.9
* feature: Debian 8 support
* feature: UseDNS configuration option
* feature: allow/deny users/groups configuration options
* feature: MOTD configuration option
* bugfix: adjust travis to work with chef12/ruby2

## 1.0.3

* improvement: reprioritize EtM-based MACs
* improvement: move SHA1 KEX algos from default to weak profile

## 1.0.2

* feature: separate options for server and client configuration
* feature: add back GCM-based ciphers
* feature: remove legacy SSHv1 options
* improvement: add more spec tests
* bugfix: restart ssh service on changes

## unreleased

* new attributes node['ssh']['client']['cbc_required'] and node['ssh']['server']['cbc_required'] replace node['ssh']['cbc_required'], which has been deprecated.

* new attributes node['ssh']['client']['weak_hmac'] and node['ssh']['server']['weak_hmac'] replace node['ssh']['weak_hmac'], which has been deprecated.

* new attributes node['ssh']['client']['weak_kex'] and node['ssh']['server']['weak_kex'] replace node['ssh']['weak_kex'], which has been deprecated.

* deprecated: Manging authorized_keys for root via attributes `ssh_rootkey` and  `ssh_rootkeys` in the `users` data bag has been deprecated and emits a waning when used. Support will be removed in 2.x.

## 1.0.1

* feature: cipher, macs and key exchange algorithms are now correctly detected on
  ubuntu 12.04+14.04, centos/oracle/redhat 6.4+6.5, debian 6+7
* feature: UsePAM can now be configured. Locked accounts may not get access via SSH
  if UsePAM is disabled (which is the default)
* feature: AllowTcpForwarding is now configurable. It is safe to set it if the user
  has a login shell anyway
* improvement: introduced rubocop+foodcritic for linting. As a result, there has been
  a long list of cleanups and fixes to make this project looking well-rounded again
* bugfixes: incorrect crypto-configuration on red-hat based systems and debian

## 1.0.0

* imported ssh hardening project and updated to current version with full test suite
