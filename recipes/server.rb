# encoding: utf-8
#
# Cookbook Name:: ssh-hardening
# Recipe:: ssh_server.rb
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

# installs package name
package 'openssh-server' do
  package_name node['sshserver']['package']
end

# defines the sshd service
service 'sshd' do
  # use upstart for ubuntu, otherwise chef uses init
  # @see http://docs.opscode.com/resource_service.html#providers
  case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 12.04
      provider Chef::Provider::Service::Upstart
    end
  end
  service_name node['sshserver']['service_name']
  supports value_for_platform(
    'centos' => { 'default' => [:restart, :reload, :status] },
    'redhat' => { 'default' => [:restart, :reload, :status] },
    'fedora' => { 'default' => [:restart, :reload, :status] },
    'scientific' => { 'default' => [:restart, :reload, :status] },
    'arch' => { 'default' => [:restart] },
    'debian' => { 'default' => [:restart, :reload, :status] },
    'ubuntu' => {
      '8.04' => [:restart, :reload],
      'default' => [:restart, :reload, :status]
    },
    'default' => { 'default' => [:restart, :reload] }
  )
  action [:enable, :start]
end

directory '/etc/ssh' do
  mode 0755
  owner 'root'
  group 'root'
  action :create
end

template '/etc/ssh/sshd_config' do
  source 'opensshd.conf.erb'
  mode 0600
  owner 'root'
  group 'root'
  variables(
    mac: SshMac.get_macs(node, node['ssh']['weak_hmac']),
    kex: SshKex.get_kexs(node, node['ssh']['weak_kex']),
    cipher: SshCipher.get_ciphers(node, node['ssh']['cbc_required'])
  )
  notifies :restart, 'service[sshd]'
end

def get_key_from(field)
  search('users', "#{field}:*").map do |v| # ~FC003 ignore footcritic violation
    Chef::Log.info "ssh_server: installing ssh-keys for root access of user #{v['id']}"
    v[field]
  end.flatten
end

keys = get_key_from('ssh_rootkey') + get_key_from('ssh_rootkeys')
Chef::Log.info 'ssh_server: not setting up any ssh keys' if keys.empty?

directory '/root/.ssh' do
  mode 0500
  owner 'root'
  group 'root'
  action :create
end

template '/root/.ssh/authorized_keys' do
  source 'authorized_keys.erb'
  mode 0400
  owner 'root'
  group 'root'
  variables(
    keys: keys
  )
  only_if { !keys.empty? }
end

execute 'unlock root account if it is locked' do
  command "sed 's/^root:\!/root:*/' /etc/shadow -i"
  only_if { node['ssh']['allow_root_with_key'] }
end
