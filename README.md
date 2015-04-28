# ssh-hardening (Chef cookbook)

[![Supermarket](http://img.shields.io/cookbook/v/ssh-hardening.svg)][1]
[![Build Status](http://img.shields.io/travis/hardening-io/chef-ssh-hardening.svg)][2]
[![Code Coverage](http://img.shields.io/coveralls/hardening-io/chef-ssh-hardening.svg)][3]
[![Dependencies](http://img.shields.io/gemnasium/hardening-io/chef-ssh-hardening.svg)][4]
[![Gitter Chat](https://badges.gitter.im/Join%20Chat.svg)][5]

## Description

This cookbook provides secure ssh-client and ssh-server configurations.

## Requirements

* Opscode chef

### Platform

- Debian 6, 7
- Ubuntu 12.04, 14.04
- RHEL 6.4, 6.5, 6.6
- CentOS 6.4, 6.5, 6.6
- OracleLinux 6.4, 6.5, 6.6

## Attributes

* `['network']['ipv6']['enable']` - true if IPv6 is needed
* `['ssh'][{'client', 'server'}]['cbc_required']` - true if CBC for ciphers is required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure ciphers enabled. CBC is a weak alternative. Anything weaker should be avoided and is thus not available.
* `['ssh'][{'client', 'server'}]['weak_hmac']` - true if weaker HMAC mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure HMACs enabled.
* `['ssh'][{'client', 'server'}]['weak_kex']` - true if weaker Key-Exchange (KEX) mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure KEXs enabled.
* `['ssh']['allow_root_with_key']` - `false` to disable root login altogether. Set to `true` to allow root to login via key-based mechanism.
* `['ssh']['ports']` - ports to which ssh-server should listen to and ssh-client should connect to
* `['ssh']['listen_to']` - one or more ip addresses, to which ssh-server should listen to. Default is empty, but should be configured for security reasons!
* `['ssh']['remote_hosts']` - one or more hosts, to which ssh-client can connect to. Default is empty, but should be configured for security reasons!
* `['ssh']['allow_tcp_forwarding']` - `false` to disable TCP Forwarding. Set to `true` to allow TCP Forwarding
* `['ssh']['allow_agent_forwarding']` - `false` to disable Agent Forwarding. Set to `true` to allow Agent Forwarding
* `['ssh']['use_pam']` - `false` to disable pam authentication
* `['ssh']['print_motd']` - `false` to disable printing of the MOTD
* `['ssh']['print_last_log']` - `false` to disable display of last login information
* `default['ssh']['deny_users']` - `[]` to configure `DenyUsers`, if specified login is disallowed for user names that match one of the patterns.
* `default['ssh']['allow_users']` - `[]` to configure `AllowUsers`, if specified, login is allowed only for user names that match one of the patterns.
* `default['ssh']['deny_groups']` - `[]` to configure `DenyGroups`, if specified, login is disallowed for users whose primary group or supplementary group list matches one of the patterns.
* `default['ssh']['allow_groups']` - `[]` to configure `AllowGroups`, if specified, login is allowed only for users whose primary group or supplementary group list matches one of the patterns.
* `default['ssh']['use_dns']` - `nil` to configure if sshd should look up the remote host name and check that the resolved host name for the remote IP address maps back to the very same IP address.

## Data Bags

**DEPRECATION WARNING**: Support for managing authorized_keys for the root account will be removed from this cookbook in the next major release. Please use alternative cookbooks for that.

This cookbook used to handle authorized keys for the root user, but that support will be removed in the next major release. Use other cookbooks to set up your users.

### Old behaviour:

Have users in your `data_bag/users/` directory. This cookbook looks for users inside this folder with a `ssh_rootkey`.

Example:

First you have to find out the ssh-key of the user you want to allow. A typical example for this is

    cat ~/.ssh/id_rsa.pub

If that folder doesn't exist or you don't know what this is all about, please read a SSH tutorial for your blend of operating system first.

You can now add this key to the data bag. Example for dada:

Example for `data_bags/users/dada.json`

    {
      "id" : "dada",
      // ... other stuff ...
      "ssh_rootkey" : "ssh-rsa AAAA....mail.com"
    }

You can then access

    ssh dada@yourmachines


## Usage

Add the recipes to the run_list:

    "recipe[ssh]"

This will install ssh-server and ssh-client. You can alternatively choose only one via:

    "recipe[ssh::server]"
    "recipe[ssh::client]"

Configure attributes:

    "ssh" : {
      "listen_to" : "10.2.3.4"
    }

**The default value for `listen_to` is `0.0.0.0`. It is highly recommended to change the value.**

## Local Testing

For local testing you can use vagrant and Virtualbox of VMWare to run tests locally. You will have to install Virtualbox and Vagrant on your system. See [Vagrant Downloads](http://downloads.vagrantup.com/) for a vagrant package suitable for your system. For all our tests we use `test-kitchen`. If you are not familiar with `test-kitchen` please have a look at [their guide](http://kitchen.ci/docs/getting-started).

Next install test-kitchen:

```bash
# Install dependencies
gem install bundler
bundle install

# Do lint checks
bundle exec rake lint

# Fetch tests
bundle exec thor kitchen:fetch-remote-tests

# fast test on one machine
bundle exec kitchen test default-ubuntu-1204

# test on all machines
bundle exec kitchen test

# for development
bundle exec kitchen create default-ubuntu-1204
bundle exec kitchen converge default-ubuntu-1204
```

For more information see [test-kitchen](http://kitchen.ci/docs/getting-started)

## FAQ / Pitfalls

**I can't log into my account. I have registered the client key, but it still doesn't let me it.**

If you have exhausted all typical issues (firewall, network, key missing, wrong key, account disabled etc.), it may be that your account is locked. The quickest way to find out is to look at the password hash for your user:

    sudo grep myuser /etc/shadow

If the hash includes an `!`, your account is locked:

    myuser:!:16280:7:60:7:::

The proper way to solve this is to unlock the account (`passwd -u myuser`). If the user doesn't have a password, you should can unlock it via:

    usermod -p "*" myuser

Alternatively, if you intend to use PAM, you enabled it via `['ssh']['use_pam'] = true`. PAM will allow locked users to get in with keys.


**Why doesn't my application connect via SSH anymore?**

Always look into log files first and if possible look at the negotation between client and server that is completed when connecting.

We have seen some issues in applications (based on python and ruby) that are due to their use of an outdated crypto set. This collides with this hardening module, which reduced the list of ciphers, message authentication codes (MACs) and key exchange (KEX) algorithms to a more secure selection.

If you find this isn't enough, feel free to activate the attributes `cbc_requires` for ciphers, `weak_hmac` for MACs and `weak_kex`for KEX in the namespaces `['ssh']['client']` or `['ssh']['server']` based on where you want to support them.

## Deprecation Notices

* `node['ssh']['cbc_required']` has been deprecated in favour of `node['ssh']['client']['cbc_required']` and `node['ssh']['server']['cbc_required']`.

* `node['ssh']['weak_hmac']` has been deprecated in favour of `node['ssh']['client']['weak_hmac']` and `node['ssh']['server']['weak_hmac']`.

* `node['ssh']['weak_kex']` has been deprecated in favour of `node['ssh']['client']['weak_kex']` and `node['ssh']['server']['weak_kex']`.

* The old attributes are still supported but will be removed in the future. In case one of the legacy attributes is set, it still precedes the newly added attributes to allow for backward compatibility.

## Contributors + Kudos

* Dominik Richter [arlimus](https://github.com/arlimus)
* Christoph Hartmann [chris-rock](https://github.com/chris-rock)
* Bernhard Weisshuhn (a.k.a. bernhorst) [bkw](https://github.com/bkw)
* Patrick Meier [atomic111](https://github.com/atomic111)
* Edmund Haselwanter [ehaselwanter](https://github.com/ehaselwanter)
* Dana Merrick [dmerrick](https://github.com/dmerrick)
* Anton Rieder [aried3r](https://github.com/aried3r)
* Trent Petersen [Rockstar04](https://github.com/Rockstar04)
* Petri Sirkkala [sirkkalap](https://github.com/sirkkalap)
* Jan Klare [jklare](https://github.com/jklare)
* Zac Hallett [zhallett](https://github.com/zhallett)
* Petri Sirkkala [sirkkalap](https://github.com/sirkkalap)
* [stribika](https://github.com/stribika)

This cookbook is mostly based on guides by:

* [NSA: Guide to the Secure Configuration of Red Hat Enterprise Linux 5](http://www.nsa.gov/ia/_files/os/redhat/rhel5-pamphlet-i731.pdf)
* [Deutsche Telekom, Group IT Security, Security Requirements (German)](http://www.telekom.com/static/-/155996/7/technische-sicherheitsanforderungen-si)

Thanks to all of you!!

## Contributing

See [contributor guideline](CONTRIBUTING.md).

## License and Author

* Author:: Dominik Richter <dominik.richter@googlemail.com>
* Author:: Deutsche Telekom AG

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.



[1]: https://supermarket.getchef.com/cookbooks/ssh-hardening
[2]: http://travis-ci.org/hardening-io/chef-ssh-hardening
[3]: https://coveralls.io/r/hardening-io/chef-ssh-hardening
[4]: https://gemnasium.com/hardening-io/chef-ssh-hardening
[5]: https://gitter.im/hardening-io
