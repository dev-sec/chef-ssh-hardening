# encoding: UTF-8
#
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

require 'spec_helper'

describe 'ssh-hardening::server' do

  # converge
  cached(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  it 'installs openssh-server' do
    expect(chef_run).to install_package('openssh-server')
  end

  it 'creates /etc/ssh/sshd_config' do
    expect(chef_run).to create_template('/etc/ssh/sshd_config')
      .with(mode: '0600')
      .with(owner: 'root')
      .with(group: 'root')
  end

  it 'enables the ssh server' do
    expect(chef_run).to enable_service('sshd')
  end

  it 'starts the server' do
    expect(chef_run).to start_service('sshd')
  end

  it 'creates the directory /etc/ssh' do
    expect(chef_run).to create_directory('/etc/ssh')
      .with(mode: '0755')
      .with(owner: 'root')
      .with(group: 'root')
  end

  it 'disables weak hmacs' do
    expect(chef_run).not_to render_file('/etc/ssh/sshd_config')
      .with_content(/MACs [^#]*\bhmac-sha1\b/)
  end

  it 'disables weak kexs' do
    expect(chef_run).not_to render_file('/etc/ssh/sshd_config')
      .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
  end

  it 'disables cbc ciphers' do
    expect(chef_run).not_to render_file('/etc/ssh/sshd_config')
      .with_content(/Ciphers [^#]*-cbc\b/)
  end

  it 'enables ctr ciphers' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config')
      .with_content(/Ciphers [^#]*\baes128-ctr\b/)
      .with_content(/Ciphers [^#]*\baes192-ctr\b/)
      .with_content(/Ciphers [^#]*\baes256-ctr\b/)
  end

  context 'with weak hmacs enabled' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    it 'allows weak hmacs' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config')
        .with_content(/MACs [^#]*\bhmac-sha1\b/)
    end

    it 'still does not allow weak kexs' do
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config')
        .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end

    it 'still doss not allow cbc ciphers' do
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config')
        .with_content(/Ciphers [^#]*-cbc\b/)
    end
  end

  context 'with weak kexs enabled' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['weak_kex'] = true
      end.converge(described_recipe)
    end

    it 'allows weak kexs' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config')
        .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end

    it 'still does not allow weak macs' do
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config')
        .with_content(/MACs [^#]*\bhmac-sha1\b/)
    end

    it 'still does not allow cbc ciphers' do
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config')
        .with_content(/Ciphers [^#]*-cbc\b/)
    end
  end

  context 'with cbc required' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['cbc_required'] = true
      end.converge(described_recipe)
    end

    it 'allows cbc ciphers' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config')
        .with_content(/Ciphers [^#]*\baes256-cbc\b/)
        .with_content(/Ciphers [^#]*\baes192-cbc\b/)
        .with_content(/Ciphers [^#]*\baes128-cbc\b/)
    end

    it 'still does not allow weak macs' do
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config')
        .with_content(/MACs [^#]*\bhmac-sha1\b/)
    end

    it 'still does not allow weak kexs' do
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config')
        .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end

    it 'still enables ctr ciphers' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config')
        .with_content(/Ciphers [^#]*\baes128-ctr\b/)
        .with_content(/Ciphers [^#]*\baes192-ctr\b/)
        .with_content(/Ciphers [^#]*\baes256-ctr\b/)
    end
  end

  it 'restarts the ssh server on config changes' do
    resource = chef_run.template('/etc/ssh/sshd_config')
    expect(resource).to notify('service[sshd]').to(:restart).delayed
  end

  it 'creates .ssh directory for user root' do
    expect(chef_run).to create_directory('/root/.ssh')
      .with(mode: '0500')
      .with(owner: 'root')
      .with(group: 'root')
  end

  context 'without attribute allow_root_with_key' do
    it 'does not unlock root account' do
      expect(chef_run).to_not run_execute('unlock root account if it is locked')
    end
  end

  context 'with attribute allow_root_with_key' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['allow_root_with_key'] = true
      end.converge(described_recipe)
    end

    it 'unlocks root account' do
      expect(chef_run).to run_execute('unlock root account if it is locked')
        .with(command: "sed 's/^root:\!/root:*/' /etc/shadow -i")
    end
  end

  context 'with users data bag' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |_node, server|
        server.create_data_bag(
        'users',
        'user1' => { id: 'user1', ssh_rootkey: 'key-user1' },
        'user2' => { id: 'user2', ssh_rootkey: 'key-user2' },
        'user3' => { id: 'user3', ssh_rootkeys: %w(key1-user3 key2-user3) },
        'user4' => { id: 'user4', ssh_rootkeys: %w(key1-user4) }
      )
      end.converge(described_recipe)
    end

    it 'creates authorized_keys for root' do
      expect(chef_run).to create_template('/root/.ssh/authorized_keys')
        .with(mode: '0400')
        .with(owner: 'root')
        .with(group: 'root')
    end

    it 'authorizes keys from the user data bag for root access' do
      expect(chef_run).to render_file('/root/.ssh/authorized_keys')
        .with_content(/^key-user1$/)
        .with_content(/^key-user2$/)
        .with_content(/^key1-user3$/)
        .with_content(/^key2-user3$/)
        .with_content(/^key1-user4$/)
    end

  end

  context 'without users data bag' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end

    it 'does not raise an error' do
      expect { chef_run }.not_to raise_error
    end

    it 'does not touch authorized_keys by root' do
      expect(chef_run).to_not create_template('/root/.ssh/authorized_keys')
    end
  end
end
