Description
===========

This cookbook provides ssh-client and ssh-server configurations, focusing on ease and security-awareness.

Requirements
============

* Opscode chef

Attributes
==========

* `[:network][:ipv6][:disable]` - true if IPv6 is not needed
* `[:ssh][:cbc_required]` - true if CBC for ciphers is required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure ciphers enabled. CBC is a weak alternative. Anything weaker should be avoided and is thus not available.
* `[:ssh][:weak_hmac]` - true if weaker HMAC mechanisms are required. This is usually only necessary, if older M2M mechanism need to communicate with SSH, that don't have any of the configured secure HMACs enabled. 
* `[:ssh][:ports]` - ports to which ssh-server should listen to and ssh-client should connect to
* `[:ssh][:authorized_keys]` - authorized public keys to which ssh-server should be configured.
* `[:ssh][:listen_to]` - one or more ip addresses, to which ssh-server should listen to. Default is empty, but should be configured for security reasons!
* `[:ssh][:remote_hosts]` - one or more hosts, to which ssh-client can connect to. Default is empty, but should be configured for security reasons!

Usage
=====

Add the recipes to the run_list:
    
    "recipe[ssh]"

This will install ssh-server and ssh-client. You can alternatively choose only one via:

    "recipe[ssh::ssh_server]"
    "recipe[ssh::ssh_client]"

Configure attributes:

    "ssh" : {
      "authorized_keys" : ["ssh-rsa AAAA...com"],
      "listen_to" : "10.2.3.4"
    }

Under `listen` you can define a number of accept-rules, comprised of at least the field `proto`, which designates one or more protocols/services. `to` and `from` may take one or more ip addresses (including bitmasks) upon which the rule will act.


License and Author
==================
Author:: Dominik Richter <dominik.richter@googlemail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.