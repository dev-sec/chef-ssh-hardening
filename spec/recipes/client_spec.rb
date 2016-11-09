# encoding: UTF-8
#
# Copyright 2014, Deutsche Telekom AG
# Copyright 2016, Artem Sidorenko
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
  let(:helper_lib) { DevSec::Ssh }
  let(:ssh_config_file) { '/etc/ssh/ssh_config' }

  # converge
  cached(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  it 'installs openssh-client' do
    expect(chef_run).to install_package('openssh-client').with(
      package_name: 'openssh-client'
    )
  end

  it 'creates the directory /etc/ssh' do
    expect(chef_run).to create_directory('/etc/ssh').with(
      mode: '0755',
      owner: 'root',
      group: 'root'
    )
  end

  it 'creates /etc/ssh/ssh_config' do
    expect(chef_run).to create_template('/etc/ssh/ssh_config').with(
      source: 'openssh.conf.erb',
      mode: '0644',
      owner: 'root',
      group: 'root'
    )
  end

  include_examples 'does not allow weak hmacs'
  include_examples 'does not allow weak kexs'
  include_examples 'does not allow weak ciphers'

  it 'disables client roaming' do
    expect(chef_run).to render_file('/etc/ssh/ssh_config').
      with_content(/UseRoaming no/)
  end

  include_examples 'allow ctr ciphers'

  context 'weak_hmac enabled only for the client' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['client']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak hmacs'

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_hmac_cliet')
    end
  end

  context 'weak_hmac enabled only for the server' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['server']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak hmacs'
  end

  context 'weak_kex enabled for the client only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['client']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak kexs'

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_kex_client')
    end
  end

  context 'weak_kexs enabled for the server only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['server']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak kexs'
  end

  context 'cbc_required set for the client only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['client']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak ciphers'

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/cbc_required_client')
    end
  end

  context 'cbc_required set for the server only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['server']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak ciphers'
  end

  describe 'backward compatibility' do
    context 'legacy attribute ssl/weak_hmac set' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new do |node|
          node.normal['ssh']['weak_hmac'] = true
        end.converge(described_recipe)
      end

      include_examples 'allow weak hmacs'
      include_examples 'does not allow weak kexs'
      include_examples 'does not allow weak ciphers'

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/weak_hmac_client').with(
          message: 'ssh/client/weak_hmac set from deprecated ssh/weak_hmac',
          level: :warn
        )
      end
    end

    context 'legacy attribute weak_kex set' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new do |node|
          node.normal['ssh']['weak_kex'] = true
        end.converge(described_recipe)
      end

      include_examples 'allow weak kexs'
      include_examples 'does not allow weak hmacs'
      include_examples 'does not allow weak ciphers'

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/weak_kex_client').with(
          message: 'ssh/client/weak_kex set from deprecated ssh/weak_kex',
          level: :warn
        )
      end
    end

    context 'legacy attribute cbc_required set' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new do |node|
          node.normal['ssh']['cbc_required'] = true
        end.converge(described_recipe)
      end

      include_examples 'allow weak ciphers'
      include_examples 'does not allow weak hmacs'
      include_examples 'does not allow weak kexs'
      include_examples 'allow ctr ciphers'

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/cbc_required_client').with(
          message: 'ssh/client/cbc_required set from deprecated ssh/cbc_required',
          level: :warn
        )
      end
    end
  end

  %w(weak_hmac weak_kex cbc_required).each do |attr|
    describe "transition logic for #{attr}" do
      context "global #{attr}:true, client:false and server:true" do
        # don't use cache, log persists
        let(:chef_run) do
          ChefSpec::ServerRunner.new do |node|
            node.normal['ssh'][attr] = true
            node.normal['ssh']['client'][attr] = false
            node.normal['ssh']['server'][attr] = true
          end.converge(described_recipe)
        end

        it "warns about ignoring the global #{attr} value for the client" do
          expect(chef_run).to write_log("ignored-ssh/#{attr}_client").with(
            message: "Ignoring ssh/#{attr}:true for client",
            level: :warn
          )
        end
      end

      context "global #{attr}:true, client:true and server:false" do
        # don't use cache, log persists
        let(:chef_run) do
          ChefSpec::ServerRunner.new do |node|
            node.normal['ssh'][attr] = true
            node.normal['ssh']['client'][attr] = true
            node.normal['ssh']['server'][attr] = false
          end.converge(described_recipe)
        end

        it "does not warn about ignoring the global #{attr}" do
          expect(chef_run).not_to write_log("ignored-ssh/#{attr}_client").with(
            level: :warn
          )
        end
      end
    end
  end

  context 'chef-solo' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'does not raise an error' do
      expect { chef_run }.not_to raise_error
    end
  end
end
