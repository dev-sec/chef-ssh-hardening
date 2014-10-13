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

describe 'ssh-hardening::client' do

  # converge
  cached(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  it 'installs openssh-client' do
    expect(chef_run).to install_package('openssh-client')
  end

  it 'creates the directory /etc/ssh' do
    expect(chef_run).to create_directory('/etc/ssh')
      .with(mode: '0755')
      .with(owner: 'root')
      .with(group: 'root')
  end

  it 'creates /etc/ssh/ssh_config' do
    expect(chef_run).to create_template('/etc/ssh/ssh_config')
      .with(owner: 'root')
      .with(group: 'root')
      .with(mode: '0644')
  end

  it 'disables weak hmacs' do
    expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
      .with_content(/MACs [^#]*\bhmac-sha1\b/)
  end

  it 'disables weak kexs' do
    expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
      .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
  end

  it 'disables cbc ciphers' do
    expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
      .with_content(/Ciphers [^#]*-cbc\b/)
  end

  it 'enables ctr ciphers' do
    expect(chef_run).to render_file('/etc/ssh/ssh_config')
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
      expect(chef_run).to render_file('/etc/ssh/ssh_config')
        .with_content(/MACs [^#]*\bhmac-sha1\b/)
    end

    it 'still does not allow weak kexs' do
      expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
        .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end

    it 'still doss not allow cbc ciphers' do
      expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
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
      expect(chef_run).to render_file('/etc/ssh/ssh_config')
        .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end

    it 'still does not allow weak macs' do
      expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
        .with_content(/MACs [^#]*\bhmac-sha1\b/)
    end

    it 'still does not allow cbc ciphers' do
      expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
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
      expect(chef_run).to render_file('/etc/ssh/ssh_config')
        .with_content(/Ciphers [^#]*\baes256-cbc\b/)
        .with_content(/Ciphers [^#]*\baes192-cbc\b/)
        .with_content(/Ciphers [^#]*\baes128-cbc\b/)
    end

    it 'still does not allow weak macs' do
      expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
        .with_content(/MACs [^#]*\bhmac-sha1\b/)
    end

    it 'still does not allow weak kexs' do
      expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
        .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end

    it 'still enables ctr ciphers' do
      expect(chef_run).to render_file('/etc/ssh/ssh_config')
        .with_content(/Ciphers [^#]*\baes128-ctr\b/)
        .with_content(/Ciphers [^#]*\baes192-ctr\b/)
        .with_content(/Ciphers [^#]*\baes256-ctr\b/)
    end

  end
end
