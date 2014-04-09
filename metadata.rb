name             "ssh-hardening"
maintainer       "Dominik Richter"
maintainer_email "dominik.richter@googlemail.com"
license          "Apache 2.0"
description      "Installs/Configures ssh"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

recipe 'ssh-hardening::default', 'installs and configures ssh client and server'
recipe 'ssh-hardening::client', 'install and apply security hardening for ssh client'
recipe 'ssh-hardening::server', 'install and apply security hardening for ssh server'

