# encoding: utf-8
#
# Cookbook Name:: ssh-hardening
# Recipe:: server.rb
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
  package_name node['ssh-hardening']['sshserver']['package']
end

# defines the sshd service
service 'sshd' do
  # use upstart for ubuntu, otherwise chef uses init
  # @see http://docs.opscode.com/resource_service.html#providers
  case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 15.04
      provider Chef::Provider::Service::Systemd
    elsif node['platform_version'].to_f >= 12.04
      provider Chef::Provider::Service::Upstart
    end
  end
  service_name node['ssh-hardening']['sshserver']['service_name']
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

directory 'openssh-server ssh directory /etc/ssh' do
  path '/etc/ssh'
  mode '0755'
  owner 'root'
  group 'root'
end

# warn about cipher depreciations and support legacy attributes
%w(weak_hmac weak_kex cbc_required).each do |setting|
  next unless node['ssh-hardening']['ssh'][setting]
  # If at least one of the specific client/server attributes was used,
  # we assume the global attribute to be a leftover from previous runs and
  # just ignore it.
  #
  # If both client and server settings are default (false) we use the global
  # value for both client and server for backward compatibility - the user may
  # not have noticed the new attributes yet and did request the weak settings
  # in the past. We don't want to break too many things.
  if !node['ssh-hardening']['ssh']['server'][setting] && !node['ssh-hardening']['ssh']['client'][setting]
    log "deprecated-ssh/#{setting}_server" do
      message "ssh/server/#{setting} set from deprecated ssh/#{setting}"
      level :warn
    end
    node.default['ssh-hardening']['ssh']['server'][setting] = node['ssh-hardening']['ssh'][setting]
  else
    log "ignored-ssh/#{setting}_server" do
      message "Ignoring ssh/#{setting}:true for server"
      only_if { !node['ssh-hardening']['ssh']['server'][setting] }
      level :warn
    end
  end
end

template '/etc/ssh/sshd_config' do
  source 'opensshd.conf.erb'
  mode '0600'
  owner 'root'
  group 'root'
  variables(
    mac:    node['ssh-hardening']['ssh']['server']['mac']    || DevSec::Ssh.get_server_macs(node['ssh-hardening']['ssh']['server']['weak_hmac']),
    kex:    node['ssh-hardening']['ssh']['server']['kex']    || DevSec::Ssh.get_server_kexs(node['ssh-hardening']['ssh']['server']['weak_kex']),
    cipher: node['ssh-hardening']['ssh']['server']['cipher'] || DevSec::Ssh.get_server_ciphers(node['ssh-hardening']['ssh']['server']['cbc_required']),
    use_priv_sep: node['ssh-hardening']['ssh']['use_privilege_separation'] || DevSec::Ssh.get_server_privilege_separarion,
    deny_users: node['ssh-hardening']['ssh']['deny_users'],
    allow_users: node['ssh-hardening']['ssh']['allow_users'],
    deny_groups: node['ssh-hardening']['ssh']['deny_groups'],
    allow_groups: node['ssh-hardening']['ssh']['allow_groups']
  )
  notifies :restart, 'service[sshd]'
end

execute 'unlock root account if it is locked' do
  command "sed 's/^root:\!/root:*/' /etc/shadow -i"
  only_if { node['ssh-hardening']['ssh']['allow_root_with_key'] }
end
