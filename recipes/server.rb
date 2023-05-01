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

# default attributes
# We can not set this kind of defaults in the attribute files
# as we react on value of other attributes
# https://github.com/dev-sec/chef-ssh-hardening/issues/140#issuecomment-267779720
node.default['ssh-hardening']['ssh']['server']['listen_to'] =
  if node['ssh-hardening']['network']['ipv6']['enable']
    ['0.0.0.0', '::']
  else
    ['0.0.0.0']
  end

# some internal definitions
cache_dir = ::File.join(Chef::Config[:file_cache_path], cookbook_name.to_s)
dh_moduli_file = '/etc/ssh/moduli'

# create a cache dir for this cookbook
# we use it for storing of lock files or selinux files
directory cache_dir

# installs package name
ohai 'reload openssh-server' do
  action :nothing
end

package 'openssh-server' do
  package_name node['ssh-hardening']['sshserver']['package']
  # we need to reload the package version, otherwise we get the version that was installed before cookbook execution
  notifies :reload, 'ohai[reload openssh-server]', :immediately
end

# Handle additional SELinux policy on RHEL/Fedora for different UsePAM options
if %w[fedora rhel].include?(node['platform_family'])
  policy_file = ::File.join(cache_dir, 'ssh_password.te')
  module_file = ::File.join(cache_dir, 'ssh_password.mod')
  package_file = ::File.join(cache_dir, 'ssh_password.pp')

  package node['ssh-hardening']['selinux']['package']

  if node['ssh-hardening']['ssh']['server']['use_pam']
    # UsePAM yes: disable and remove the additional SELinux policy

    execute 'remove selinux policy' do
      command 'semodule -r ssh_password'
      only_if 'getenforce | grep -vq Disabled && semodule -l | grep -q ssh_password'
    end
  else
    # UsePAM no: enable and install the additional SELinux policy

    cookbook_file policy_file do
      source 'ssh_password.te'
    end

    bash 'build selinux package and install it' do
      code <<-EOC
        checkmodule -M -m -o #{module_file} #{policy_file}
        semodule_package -o #{package_file} -m #{module_file}
        semodule -i #{package_file}
      EOC
      not_if 'getenforce | grep -q Disabled || semodule -l | grep -q ssh_password'
    end
  end
end

# handle Diffie-Hellman moduli
# build own moduli file if required
own_primes_lock_file = ::File.join(cache_dir, 'moduli.lock')
bash 'build own primes for DH' do
  code <<-EOS
    set -e
    tempdir=$(mktemp -d)
    ssh-keygen -G $tempdir/moduli.all -b #{node['ssh-hardening']['ssh']['server']['dh_build_primes_size']}
    ssh-keygen -T $tempdir/moduli.safe -f $tempdir/moduli.all
    cp $tempdir/moduli.safe #{dh_moduli_file}
    rm -rf $tempdir
    touch #{own_primes_lock_file}
  EOS
  only_if { node['ssh-hardening']['ssh']['server']['dh_build_primes'] }
  not_if { ::File.exist?(own_primes_lock_file) }
  notifies :restart, 'service[sshd]'
end

# remove all small primes
# https://stribika.github.io/2015/01/04/secure-secure-shell.html
dh_min_prime_size = node['ssh-hardening']['ssh']['server']['dh_min_prime_size'].to_i - 1 # 4096 is 4095 in the moduli file
ruby_block 'remove small primes from DH moduli' do # ~FC014
  block do
    tmp_file = "#{dh_moduli_file}.tmp"
    ::File.open(tmp_file, 'w') do |new_file|
      ::File.readlines(dh_moduli_file).each do |line|
        unless line_match = line.match(/^(\d+ ){4}(\d+) \d+ \h+$/) # rubocop:disable Lint/AssignmentInCondition
          # some line without expected data structure, e.g. comment line
          # write it and go to the next data
          new_file.write(line)
          next
        end

        # lets compare the bits and do not write the lines with small bit size
        bits = line_match[2]
        new_file.write(line) unless bits.to_i < dh_min_prime_size
      end
    end

    # we use cp&rm to preserve the permissions of existing file
    FileUtils.cp(tmp_file, dh_moduli_file)
    FileUtils.rm(tmp_file)
  end
  not_if "test $(awk '$5 < #{dh_min_prime_size} && $5 ~ /^[0-9]+$/ { print $5 }' #{dh_moduli_file} | uniq | wc -c) -eq 0"
  notifies :restart, 'service[sshd]'
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
    'centos' => { 'default' => %i[restart reload status] },
    'redhat' => { 'default' => %i[restart reload status] },
    'fedora' => { 'default' => %i[restart reload status] },
    'scientific' => { 'default' => %i[restart reload status] },
    'arch' => { 'default' => [:restart] },
    'debian' => { 'default' => %i[restart reload status] },
    'ubuntu' => {
      '8.04' => %i[restart reload],
      'default' => %i[restart reload status]
    },
    'default' => { 'default' => %i[restart reload] }
  )
  action %i[enable start]
end

directory 'openssh-server ssh directory /etc/ssh' do
  path '/etc/ssh'
  mode '0755'
  owner 'root'
  group 'root'
end

template '/etc/ssh/sshd_config' do
  source 'opensshd.conf.erb'
  mode '0600'
  owner 'root'
  group 'root'
  variables(
    # we do lazy here to ensure we detect the version that comes with the package update above
    lazy do
      {
        permit_tunnel: DevSec::Ssh.validate_permit_tunnel(node['ssh-hardening']['ssh']['server']['permit_tunnel']),
        mac:          node['ssh-hardening']['ssh']['server']['mac']    || DevSec::Ssh.get_server_macs(node['ssh-hardening']['ssh']['server']['weak_hmac']),
        kex:          node['ssh-hardening']['ssh']['server']['kex']    || DevSec::Ssh.get_server_kexs(node['ssh-hardening']['ssh']['server']['weak_kex']),
        cipher:       node['ssh-hardening']['ssh']['server']['cipher'] || DevSec::Ssh.get_server_ciphers(node['ssh-hardening']['ssh']['server']['cbc_required']),
        use_priv_sep: node['ssh-hardening']['ssh']['use_privilege_separation'] || DevSec::Ssh.get_server_privilege_separarion,
        hostkeys:     node['ssh-hardening']['ssh']['server']['host_key_files'] || DevSec::Ssh.get_server_algorithms.map { |alg| "/etc/ssh/ssh_host_#{alg}_key" },
        version:      DevSec::Ssh.get_ssh_server_version
      }
    end
  )
  notifies :restart, 'service[sshd]'
end

execute 'unlock root account if it is locked' do
  command "sed 's/^root:\!/root:*/' /etc/shadow -i"
  only_if { node['ssh-hardening']['ssh']['allow_root_with_key'] }
end
