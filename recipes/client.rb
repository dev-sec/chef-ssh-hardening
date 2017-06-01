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
  package_name node['ssh-hardening']['sshclient']['package']
end

directory 'openssh-client ssh directory /etc/ssh' do
  path '/etc/ssh'
  mode '0755'
  owner 'root'
  group 'root'
end

template '/etc/ssh/ssh_config' do
  source 'openssh.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables(
    mac:     node['ssh-hardening']['ssh']['client']['mac']    || DevSec::Ssh.get_client_macs(node['ssh-hardening']['ssh']['client']['weak_hmac']),
    kex:     node['ssh-hardening']['ssh']['client']['kex']    || DevSec::Ssh.get_client_kexs(node['ssh-hardening']['ssh']['client']['weak_kex']),
    cipher:  node['ssh-hardening']['ssh']['client']['cipher'] || DevSec::Ssh.get_client_ciphers(node['ssh-hardening']['ssh']['client']['cbc_required'])
  )
end
