#
# Cookbook Name:: ssh
# Recipe:: ssh_client.rb
#
# Copyright 2012, Dominik Richter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "openssh-client"

directory "/etc/ssh" do
  mode 0555
  owner "root"
  group "root"
  action :create
end

template "/etc/ssh/ssh_config" do
  source "openssh.conf.erb"
  mode 0444
  owner "root"
  group "root"
  variables(
    :hosts => node[:ssh][:remote_hosts],
    :ssh_ports => node[:ssh][:ports],
    :address_family => ((node[:network][:ipv6][:enable]) ? "any" : "inet" ),
    # CBC: is true if you want to connect with OpenSSL-base libraries
    #      eg ruby Net::SSH::Transport::CipherFactory requires cbc-versions
    #      of the given openssh ciphers to work
    #      eg see: http://net-ssh.github.com/net-ssh/classes/Net/SSH/Transport/CipherFactory.html
    :cbc_required => node[:ssh][:cbc_required],
    # weak hmac is sometimes required if older package versions are used
    # eg ruby's Net::SSH at around 2.2.* doesn't support sha2 for hmac,
    #    so this will have to be set true in this case.
    # activating this rule will enable sha1 for hmac
    :weak_hmac => node[:ssh][:weak_hmac],
    # weak hmac is sometimes required if older package versions are used
    # eg ruby's Net::SSH at around 2.2.* doesn't support sha2 for hmac,
    #    so this will have to be set true in this case.
    # activating this rule will enable sha1 for kex
    :weak_kex => node[:ssh][:weak_kex]
  )
end
