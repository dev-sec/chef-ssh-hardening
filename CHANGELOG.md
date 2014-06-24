# Changelog

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
