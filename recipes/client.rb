# encoding: utf-8
#
# Cookbook Name:: ssh-hardening
# Recipe:: client.rb
#
# Copyright 2012, Dominik Richter
# Copyright 2014, Deutsche Telekom AG
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

package 'openssh-client' do
  package_name node['sshclient']['package']
end

directory '/etc/ssh' do
  mode '0755'
  owner 'root'
  group 'root'
  action :create
end

# warn about cipher depreciations and support legacy attributes
%w(weak_hmac weak_kex cbc_required).each do |setting|
  next unless node['ssh'][setting]
  # If at least one of the specific client/server attributes was used,
  # we assume the global attribute to be a leftover from previous runs and
  # just ignore it.
  #
  # If both client and server settings are default (false) we use the global
  # value for both client and server for backward compatibility - the user may
  # not have noticed the new attributes yet and did request the weak settings
  # in the past. We don't want to break too many things.
  if !node['ssh']['client'][setting] && !node['ssh']['server'][setting]
    log "deprecated-ssh/#{setting}_client" do
      message "ssh/client/#{setting} set from deprecated ssh/#{setting}"
      level :warn
    end
    node.set['ssh']['client'][setting] = node['ssh'][setting]
  else
    log "ignored-ssh/#{setting}_client" do
      message "Ignoring ssh/#{setting}:true for client"
      only_if { !node['ssh']['client'][setting] }
      level :warn
    end
  end
end

template '/etc/ssh/ssh_config' do
  source 'openssh.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    mac: SshMac.get_macs(node, node['ssh']['client']['weak_hmac']),
    kex: SshKex.get_kexs(node, node['ssh']['client']['weak_kex']),
    cipher: SshCipher.get_ciphers(node, node['ssh']['client']['cbc_required'])
  )
end
