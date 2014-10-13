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

  context 'weak_hmac enabled only for the client' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['client']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    it 'allows weak hmacs for the client' do
      expect(chef_run).to render_file('/etc/ssh/ssh_config')
        .with_content(/MACs [^#]*\bhmac-sha1\b/)
    end

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_hmac_cliet')
    end
  end

  context 'weak_hmac enabled only for the server' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['server']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    it 'does not enable weak hmacs on the client' do
      expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
        .with_content(/MACs [^#]*\bhmac-sha1\b/)
    end
  end

  context 'weak_kex enabled for the client only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['client']['weak_kex'] = true
      end.converge(described_recipe)
    end

    it 'allows weak kexs on the client' do
      expect(chef_run).to render_file('/etc/ssh/ssh_config')
        .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_kex_client')
    end
  end

  context 'weak_kexs enabled for the server only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['server']['weak_kex'] = true
      end.converge(described_recipe)
    end

    it 'does not allow weak kexs on the client' do
      expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
        .with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end
  end

  context 'cbc_required set for the client only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['client']['cbc_required'] = true
      end.converge(described_recipe)
    end

    it 'allows cbc ciphers on the client' do
      expect(chef_run).to render_file('/etc/ssh/ssh_config')
        .with_content(/Ciphers [^#]*\baes256-cbc\b/)
        .with_content(/Ciphers [^#]*\baes192-cbc\b/)
        .with_content(/Ciphers [^#]*\baes128-cbc\b/)
    end

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/cbc_required_client')
    end
  end

  context 'cbc_required set for the server only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['server']['cbc_required'] = true
      end.converge(described_recipe)
    end

    it 'does not allow cbc ciphers on the client' do
      expect(chef_run).not_to render_file('/etc/ssh/ssh_config')
        .with_content(/Ciphers [^#]*\b.*-cbc\b/)
    end
  end

  describe 'backward compatibility' do
    context 'legacy attribute ssl/weak_hmac set' do
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

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/weak_hmac_client')
          .with(message: /deprecated/)
          .with(level: :warn)
      end
    end

    context 'legacy attribute weak_kex set' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new do |node|
          node.set['ssh']['weak_kex'] = true
        end.converge(described_recipe)
      end

      it 'allows weak kexs on the client' do
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

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/weak_kex_client')
          .with(message: /deprecated/)
          .with(level: :warn)
      end
    end

    context 'legacy attribute cbc_required set' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new do |node|
          node.set['ssh']['cbc_required'] = true
        end.converge(described_recipe)
      end

      it 'allows cbc ciphers for the client' do
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

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/cbc_required_client')
          .with(message: /deprecated/)
          .with(level: :warn)
      end
    end
  end

  %w(weak_hmac weak_kex cbc_required).each do |attr|
    describe "transition logic for #{attr}" do
      context "global #{attr}:true, client:false and server:true" do
        # don't use cache, log persists
        let(:chef_run) do
          ChefSpec::ServerRunner.new do |node|
            node.set['ssh'][attr] = true
            node.set['ssh']['client'][attr] = false
            node.set['ssh']['server'][attr] = true
          end.converge(described_recipe)
        end

        it "warns about ignoring the global #{attr} value for the client" do
          expect(chef_run).to write_log("ignored-ssh/#{attr}_client")
            .with(message: "Ignoring ssh/#{attr}:true for client")
            .with_level(:warn)
        end
      end

      context "global #{attr}:true, client:true and server:false" do
        # don't use cache, log persists
        let(:chef_run) do
          ChefSpec::ServerRunner.new do |node|
            node.set['ssh'][attr] = true
            node.set['ssh']['client'][attr] = true
            node.set['ssh']['server'][attr] = false
          end.converge(described_recipe)
        end

        it "does not warn about ignoring the global #{attr}" do
          expect(chef_run).not_to write_log("ignored-ssh/#{attr}_client")
            .with_level(:warn)
        end
      end
    end
  end
end
