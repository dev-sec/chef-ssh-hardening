# ssh-hardening (Chef cookbook)

[![Supermarket](http://img.shields.io/cookbook/v/ssh-hardening.svg)][1]
[![Build Status](https://travis-ci.org/dev-sec/chef-ssh-hardening.svg?branch=master)][2]
[![Code Coverage](http://img.shields.io/coveralls/dev-sec/chef-ssh-hardening.svg)][3]
[![Gitter Chat](https://badges.gitter.im/Join%20Chat.svg)][4]

## Description

This cookbook provides secure ssh-client and ssh-server configurations. This cookbook does not provide capabilities for management of users and/or ssh keys, please use other cookbooks for that.

## Requirements

* Chef >= 14.13.11

### Platform

- Debian 8, 9, 10
- Ubuntu 16.04, 18.04
- RHEL 6, 7
- CentOS 6, 7
- Oracle Linux 6, 7
- Fedora 29, 30
- OpenSuse Leap 42
- Amazon Linux 1, 2

## Attributes

Below you can find the attribute documentation and their default values.

Notice: Some of attribute defaults of this cookbook are set in the recipes. You should use a higher [attribute precedence](https://docs.chef.io/attributes.html#attribute-precedence) level for overriding of such attributes. Such attributes are flagged with `#override attribute#` in the list below. Example for overriding a such attribute:

```ruby
override['ssh-hardening']['ssh']['server']['listen_to'] = node['ipaddress']
```

* `['ssh-hardening']['network']['ipv6']['enable']` - `false`. Set to true if IPv6 is needed
* `['ssh-hardening']['ssh']['ports']` - `22`. Ports to which ssh-server should listen to and ssh-client should connect to
* `['ssh-hardening']['ssh'][{'client', 'server'}]['kex']` - `nil` to calculate best key-exchange (KEX) based on server version, otherwise specify a string of Kex values
* `['ssh-hardening']['ssh'][{'client', 'server'}]['mac']` - `nil` to calculate best Message Authentication Codes (MACs) based on server version, otherwise specify a string of Mac values
* `['ssh-hardening']['ssh'][{'client', 'server'}]['cipher']` - `nil` to calculate best ciphers based on server version, otherwise specify a string of Cipher values
* `['ssh-hardening']['ssh'][{'client', 'server'}]['cbc_required']` - `false`. Set to `true` if CBC for ciphers is required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure ciphers enabled. CBC is a weak alternative. Anything weaker should be avoided and is thus not available.
* `['ssh-hardening']['ssh'][{'client', 'server'}]['weak_hmac']` - `false`. Set to `true` if weaker HMAC mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure HMACs enabled.
* `['ssh-hardening']['ssh'][{'client', 'server'}]['weak_kex']` - `false`. Set to `true` if weaker Key-Exchange (KEX) mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure KEXs enabled.
* `['ssh-hardening']['ssh']['client']['remote_hosts']` - `[]` - one or more hosts, to which ssh-client can connect to.
* `['ssh-hardening']['ssh']['client']['password_authentication']` - `false`. Set to `true` if password authentication should be enabled.
* `['ssh-hardening']['ssh']['client']['roaming']` - `false`. Set to `true` if experimental client roaming should be enabled. This is known to cause potential issues with secrets being disclosed to malicious servers and defaults to being disabled.
* `['ssh-hardening']['ssh']['client']['extras']` - `{}`. Add extra configuration options, see [below](#extra-configuration-options) for details
* `['ssh-hardening']['ssh']['server']['host_key_files']` - `nil` to calculate best hostkey configuration based on server version, otherwise specify an array with file paths (e.g. `/etc/ssh/ssh_host_rsa_key`)
* `['ssh-hardening']['ssh']['server']['dh_min_prime_size']` - `2048` - Minimal acceptable prime length in bits in `/etc/ssh/moduli`. Primes below this number will get removed. (See [this](https://entropux.net/article/openssh-moduli/) for more information and background)
* `['ssh-hardening']['ssh']['server']['dh_build_primes']` - `false` - If own primes should be built. This rebuild happens only once and takes a lot of time (~ 1.5 - 2h on the modern hardware for 4096 length).
* `['ssh-hardening']['ssh']['server']['dh_build_primes_size']` - `4096` - Prime length which should be generated. This option is only valid if `dh_build_primes` is enabled.
* `['ssh-hardening']['ssh']['server']['listen_to']` `#override attribute#` - one or more ip addresses, to which ssh-server should listen to. Default is to listen on all interfaces. It should be configured for security reasons!
* `['ssh-hardening']['ssh']['server']['allow_root_with_key']` - `false` to disable root login altogether. Set to `true` to allow root to login via key-based mechanism
* `['ssh-hardening']['ssh']['server']['allow_tcp_forwarding']` - `false`. Set to `true` to allow TCP Forwarding
* `['ssh-hardening']['ssh']['server']['allow_agent_forwarding']` - `false`. Set to `true` to allow Agent Forwarding
* `['ssh-hardening']['ssh']['server']['allow_x11_forwarding']` - `false`. Set to `true` to allow X11 Forwarding
* `['ssh-hardening']['ssh']['server']['permit_tunnel']` - `false` to disable tun device forwarding. Set to `true` to allow tun device forwarding. Other accepted values: 'yes', 'no', 'point-to-point', 'ethernet'. See `man sshd_config` for exact behaviors. Note: you'll also need to enable `allow_tcp_forwarding`.
* `['ssh-hardening']['ssh']['server']['use_pam']` - `true`. Set to `false` to disable the pam authentication of sshd
* `['ssh-hardening']['ssh']['server']['challenge_response_authentication']` - `false`. Set to `true` to enable challenge response authentication.
* `['ssh-hardening']['ssh']['server']['deny_users']` - `[]` to configure `DenyUsers`, if specified login is disallowed for user names that match one of the patterns.
* `['ssh-hardening']['ssh']['server']['allow_users']` - `[]` to configure `AllowUsers`, if specified, login is allowed only for user names that match one of the patterns.
* `['ssh-hardening']['ssh']['server']['deny_groups']` - `[]` to configure `DenyGroups`, if specified, login is disallowed for users whose primary group or supplementary group list matches one of the patterns.
* `['ssh-hardening']['ssh']['server']['allow_groups']` - `[]` to configure `AllowGroups`, if specified, login is allowed only for users whose primary group or supplementary group list matches one of the patterns.
* `['ssh-hardening']['ssh']['server']['print_motd']` - `false`. Set to `true` to enable printing of the MOTD
* `['ssh-hardening']['ssh']['server']['print_last_log']` - `false`. Set to `true` to enable printing of last login information
* `['ssh-hardening']['ssh']['server']['banner']` - `nil`. Set a path like '/etc/issue.net' to enable the banner
* `['ssh-hardening']['ssh']['server']['os_banner']` - `false` to disable version information during the protocol handshake (debian family only). Set to `true` to enable it
* `['ssh-hardening']['ssh']['server']['use_dns']` - `nil` to use the openssh default. Set to `true` or `false` to enable/disable the DNS lookup and check of remote host
* `['ssh-hardening']['ssh']['server']['use_privilege_separation']` - `nil` to calculate the best value based on server version, otherwise set `true` or `false`
* `['ssh-hardening']['ssh']['server']['login_grace_time']` - `30s`. Time in which the login should be successfully, otherwise the user is disconnected.
* `['ssh-hardening']['ssh']['server']['max_auth_tries']` - `2`. The number of authentication attempts per connection
* `['ssh-hardening']['ssh']['server']['max_sessions']` - `10` The number of sessions per connection
* `['ssh-hardening']['ssh']['server']['password_authentication']` - `false`. Set to `true` if password authentication should be enabled
* `['ssh-hardening']['ssh']['server']['log_level']` - `verbose`. The log level of sshd. See `LogLevel` in `man 5 sshd_config` for possible values.
* `['ssh-hardening']['ssh']['server']['sftp']['enable']` - `false`. Set to `true` to enable the SFTP feature of OpenSSH daemon
* `['ssh-hardening']['ssh']['server']['sftp']['group']` - `sftponly`. Sets the `Match Group` option of SFTP to allow SFTP only for dedicated users
* `['ssh-hardening']['ssh']['server']['sftp']['chroot']` - `/home/%u`. Sets the directory where the SFTP user should be chrooted
* `['ssh-hardening']['ssh']['server']['sftp']['authorized_keys_path']` - `nil`. If not nil, full path to one or multiple space-separated authorized keys file that will be set inside the `Match Group` for SFTP-only access
* `['ssh-hardening']['ssh']['server']['sftp']['password_authentication']` - `false`. Set to `true` if password authentication should be enabled
* `['ssh-hardening']['ssh']['server']['authorized_keys_path']` - `nil`. If not nil, full path to one or multiple space-separated authorized keys file is expected.
* `['ssh-hardening']['ssh']['server']['extras']` - `{}`. Add extra configuration options, see [below](#extra-configuration-options) for details
* `['ssh-hardening']['ssh']['server']['match_blocks']` - `{}`. Match configuration block, see [below](#match-configuration-options-for-sshd) for details

## Usage

Add the recipes to the run_list:

    "recipe[ssh-hardening]"

This will install ssh-server and ssh-client. You can alternatively choose only one via:

    "recipe[ssh-hardening::server]"
    "recipe[ssh-hardening::client]"

Configure attributes:

    "ssh-hardening": {
      "ssh" : {
        "server" : {
          "listen_to" : "10.2.3.4"
        }
      }
    }

**The default value for `listen_to` is `0.0.0.0`. It is highly recommended to change the value.**

## SFTP

To enable the SFTP configuration add one of the following recipes to the run_list:

    "recipe[ssh-hardening]"
    or
    "recipe[ssh-hardening::server]"

Configure attributes:

    "ssh-hardening": {
      "ssh" : {
        "server": {
          "sftp" : {
          "enable" : true,
          "chroot" : "/home/sftp/%u",
          "group"  : "sftusers"
        }
        }
      }
    }

This will enable the SFTP Server and chroot every user in the `sftpusers` group to the `/home/sftp/%u` directory.

## Extra Configuration Options
Extra configuration options can be appended to the client or server configuration files.  This can be used to override statically set values, or add configuration options not otherwise available via attributes.

The syntax is as follows:
```
# => Extra Server Configuration
default['ssh-hardening']['ssh']['server']['extras'].tap do |extra|
  extra['#Some Comment'] = 'Heres the Comment'
  extra['AuthenticationMethods'] =  'publickey,keyboard-interactive'
end

# => Extra Client Configuration
default['ssh-hardening']['ssh']['client']['extras'].tap do |extra|
  extra['PermitLocalCommand'] = 'no'
  extra['Tunnel'] =  'no'
end
```

## Match Configuration Options for sshd
Match blocks have to be placed by the end of sshd_config. This can be achieved by using the `match_blocks` attribute tree:

```
default['ssh-hardening']['ssh']['server']['match_blocks'].tap do |match|
  match['User root'] = <<~ROOT
    AuthorizedKeysFile .ssh/authorized_keys
  ROOT
  match['User git'] = <<~GIT
    Banner none
    AuthorizedKeysCommand /bin/false
    AuthorizedKeysFile .ssh/authorized_keys
    GSSAPIAuthentication no
    PasswordAuthentication no
  GIT
end
```

## Local Testing

Please install [chef-dk](https://downloads.chef.io/chefdk), [VirtualBox](https://www.virtualbox.org/) or VMware Workstation and [Vagrant](https://www.vagrantup.com/).

Linting is checked with [rubocop](https://github.com/bbatsov/rubocop) and [foodcritic](http://www.foodcritic.io/):

```bash
$ chef exec rake lint
.....
```

Unit/spec tests are done with [chefspec](https://github.com/sethvargo/chefspec):

```bash
$ chef exec rake spec
.....
```

Integration tests are done with [test-kitchen](http://kitchen.ci/) and [inspec](https://www.inspec.io/):

```bash
$ chef exec rake kitchen
.....
# or you can use the kitchen directly
$ kitchen test
```

## FAQ / Pitfalls

**I can't log into my account. I have registered the client key, but it still doesn't let me it.**

If you have exhausted all typical issues (firewall, network, key missing, wrong key, account disabled etc.), it may be that your account is locked. The quickest way to find out is to look at the password hash for your user:

    sudo grep myuser /etc/shadow

If the hash includes an `!`, your account is locked:

    myuser:!:16280:7:60:7:::

The proper way to solve this is to unlock the account (`passwd -u myuser`). If the user doesn't have a password, you should can unlock it via:

    usermod -p "*" myuser

Alternatively, if you intend to use PAM, you enabled it via `['ssh-hardening']['ssh']['use_pam'] = true`. PAM will allow locked users to get in with keys.


**Why doesn't my application connect via SSH anymore?**

Always look into log files first and if possible look at the negotiation between client and server that is completed when connecting.

We have seen some issues in applications (based on python and ruby) that are due to their use of an outdated crypto set. This collides with this hardening module, which reduced the list of ciphers, message authentication codes (MACs) and key exchange (KEX) algorithms to a more secure selection.

If you find this isn't enough, feel free to activate the attributes `cbc_requires` for ciphers, `weak_hmac` for MACs and `weak_kex`for KEX in the namespaces `['ssh-hardening']['ssh']['client']` or `['ssh-hardening']['ssh']['server']` based on where you want to support them.

**Why can't I log to the SFTP server after I added a user to my SFTP group?**

This is a ChrootDirectory ownership problem. sshd will reject SFTP connections to accounts that are set to chroot into any directory that has ownership/permissions that sshd considers insecure. sshd's strict ownership/permissions requirements dictate that every directory in the chroot path must be owned by root and only writable by the owner. So, for example, if the chroot environment is /home must be owned by root.

See [https://wiki.archlinux.org/index.php/SFTP_chroot](https://wiki.archlinux.org/index.php/SFTP_chroot)

## Contributors + Kudos

* Dominik Richter [arlimus](https://github.com/arlimus)
* Christoph Hartmann [chris-rock](https://github.com/chris-rock)
* Bernhard Weisshuhn (a.k.a. bernhorst) [bkw](https://github.com/bkw)
* Patrick Munch [atomic111](https://github.com/atomic111)
* Edmund Haselwanter [ehaselwanter](https://github.com/ehaselwanter)
* Dana Merrick [dmerrick](https://github.com/dmerrick)
* Anton Rieder [aried3r](https://github.com/aried3r)
* Trent Petersen [Rockstar04](https://github.com/Rockstar04)
* Petri Sirkkala [sirkkalap](https://github.com/sirkkalap)
* Jan Klare [jklare](https://github.com/jklare)
* Zac Hallett [zhallett](https://github.com/zhallett)
* Petri Sirkkala [sirkkalap](https://github.com/sirkkalap)
* [stribika](https://github.com/stribika)
* Siddhant Rath [sidxz](https://github.com/sidxz)

This cookbook is mostly based on guides by:

* [NSA: Guide to the Secure Configuration of Red Hat Enterprise Linux 5](https://www.iad.gov/iad/library/ia-guidance/security-configuration/operating-systems/guide-to-the-secure-configuration-of-red-hat-enterprise.cfm)
* [Deutsche Telekom, Group IT Security, Security Requirements (German)](https://www.telekom.com/psa)

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
[2]: http://travis-ci.org/dev-sec/chef-ssh-hardening
[3]: https://coveralls.io/r/dev-sec/chef-ssh-hardening
[4]: https://gitter.im/dev-sec/general
