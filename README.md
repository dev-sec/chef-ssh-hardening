# ssh-hardening (Chef cookbook)

## Description

This cookbook provides secure ssh-client and ssh-server configurations.

## Requirements

* Opscode chef

## Attributes

* `['network']['ipv6']['enable']` - true if IPv6 is needed
* `['ssh']['cbc_required']` - true if CBC for ciphers is required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure ciphers enabled. CBC is a weak alternative. Anything weaker should be avoided and is thus not available.
* `['ssh']['weak_hmac']` - true if weaker HMAC mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure HMACs enabled. 
* `['ssh']['weak_kex']` - true if weaker Key-Exchange (KEX) mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure KEXs enabled.
* `['ssh']['allow_root_with_key']` - `false` to disable root login altogether. Set to `true` to allow root to login via key-based mechanism.
* `['ssh']['ports']` - ports to which ssh-server should listen to and ssh-client should connect to
* `['ssh']['listen_to']` - one or more ip addresses, to which ssh-server should listen to. Default is empty, but should be configured for security reasons!
* `['ssh']['remote_hosts']` - one or more hosts, to which ssh-client can connect to. Default is empty, but should be configured for security reasons!
* `['ssh']['allow_tcp_forwarding']` - `false` to disable TCP Forwarding. Set to `true` to allow TCP Forwarding
* `['ssh']['allow_agent_forwarding']` - `false` to disable Agent Forwarding. Set to `true` to allow Agent Forwarding

## Data Bags

This cookbook handles authorized keys for the root user. Use other cookbooks to set up your users.

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
gem install bundler
bundle install

# Do lint checks
bundle exec rake lint

# Fetch tests
thor kitchen:fetch-remote-tests

# Kitchen test
bundle exec kitchen list
bundle exec kitchen test default-ubuntu-1204
```

For more information see [test-kitchen](http://kitchen.ci/docs/getting-started)

## Contributors + Kudos

* Dominik Richter
* Christoph Hartmann
* Patrick Meier
* Bernhard K. Weisshuhn

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
