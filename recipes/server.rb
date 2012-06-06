#
# Cookbook Name:: ssh
# Recipe:: ssh_server.rb
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

package "openssh-server"

directory "/etc/ssh" do
  mode 0500
  owner "root"
  group "root"
  action :create
end

template "/etc/ssh/sshd_config" do
  source "opensshd.conf.erb"
  mode 0400
  owner "root"
  group "root"
  variables(
    # :ssh_ips => [ "127.0.0.1", "10.0.2.15" ],
    :ssh_ips => node[:ssh][:listen_to],
    :ssh_ports => node[:ssh][:ports],
    :host_key_files => [ ],
    :address_family => ((node[:network][:ipv6][:disable]) ? "inet" : "any" ),
    # CBC: is true if you want to connect with OpenSSL-base libraries
    #      eg ruby Net::SSH::Transport::CipherFactory requires cbc-versions
    #      of the given openssh ciphers to work
    #      eg see: http://net-ssh.github.com/net-ssh/classes/Net/SSH/Transport/CipherFactory.html
    :cbc_required => node[:ssh][:cbc_required],
    # weak hmac is sometimes required if older package versions are used
    # eg ruby's Net::SSH at around 2.2.* doesn't support sha2 for hmac,
    #    so this will have to be set true in this case.
    # activating this rule will enable sha1 for hmac
    :weak_hmac => node[:ssh][:weak_hmac]
  )
end


directory "/root/.ssh" do
  mode 0500
  owner "root"
  group "root"
  action :create
end

keys = search("users","ssh-key:*").map{|v| 
  Chef::Log.info "ssh_server: installing ssh-keys for user #{v['id']}"
  v['ssh-key'] 
}
Chef::Log.info "ssh_server: not setting up any ssh keys" if keys.empty?

template "/root/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  mode 0400
  owner "root"
  group "root"
  variables(
    :keys => keys
  )
  only_if{ not keys.empty? }
end