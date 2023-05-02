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
    ChefSpec::SoloRunner.new.converge(described_recipe)
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

  it 'sends default locale environment variables' do
    expect(chef_run).to render_file('/etc/ssh/ssh_config').
      with_content('SendEnv LANG LC_* LANGUAGE')
  end

  include_examples 'allow ctr ciphers'

  context 'weak_hmac enabled only for the client' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak hmacs'
  end

  context 'weak_hmac enabled only for the server' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak hmacs'
  end

  context 'weak_kex enabled for the client only' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak kexs'
  end

  context 'weak_kexs enabled for the server only' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak kexs'
  end

  context 'cbc_required set for the client only' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak ciphers'
  end

  context 'cbc_required set for the server only' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak ciphers'
  end

  context 'with custom KEXs' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['kex'] = 'mycustomkexvalue'
      end.converge(described_recipe)
    end

    it 'uses the value of kex attribute' do
      expect(chef_run).to render_file('/etc/ssh/ssh_config').
        with_content(/KexAlgorithms mycustomkexvalue/)
    end
  end

  context 'with custom MACs' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['mac'] = 'mycustommacvalue'
      end.converge(described_recipe)
    end

    it 'uses the value of mac attribute' do
      expect(chef_run).to render_file('/etc/ssh/ssh_config').
        with_content(/MACs mycustommacvalue/)
    end
  end

  context 'with custom ciphers' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['cipher'] = 'mycustomciphervalue'
      end.converge(described_recipe)
    end

    it 'uses the value of cipher attribute' do
      expect(chef_run).to render_file('/etc/ssh/ssh_config').
        with_content(/Ciphers mycustomciphervalue/)
    end
  end

  context 'with empty send_env attribute' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['send_env'] = []
      end.converge(described_recipe)
    end

    it 'will not send any environment variables' do
      expect(chef_run).to_not render_file('/etc/ssh/ssh_config').
        with_content(/SendEnv/)
    end
  end

  context 'with custom send_env attribute' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['send_env'] = %w[some environment variables]
      end.converge(described_recipe)
    end

    it 'uses the value of send_env attribute' do
      expect(chef_run).to render_file('/etc/ssh/ssh_config').
        with_content(/SendEnv some environment variables/)
    end
  end

  describe 'extra configuration values' do
    context 'without custom extra config value' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new.converge(described_recipe)
      end

      it 'does not have any extra config options' do
        expect(chef_run).to render_file('/etc/ssh/ssh_config')
        expect(chef_run).not_to render_file('/etc/ssh/ssh_config').
          with_content(/^# Extra Configuration Options/)
      end
    end

    context 'with custom extra config value' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.normal['ssh-hardening']['ssh']['client']['extras']['#ExtraConfig'] = 'Value'
        end.converge(described_recipe)
      end

      it 'uses the extra config attributes' do
        expect(chef_run).to render_file('/etc/ssh/ssh_config').with_content(/^# Extra Configuration Options/)
        expect(chef_run).to render_file('/etc/ssh/ssh_config').with_content(/^#ExtraConfig Value/)
      end
    end
  end

  describe 'version specific options' do
    context 'running with OpenSSH < 7.6' do
      it 'should have RhostsRSAAuthentication and RSAAuthentication' do
        expect(chef_run).to render_file('/etc/ssh/ssh_config').with_content(/RhostsRSAAuthentication/)
        expect(chef_run).to render_file('/etc/ssh/ssh_config').with_content(/RSAAuthentication/)
      end
    end

    context 'running with OpenSSH >= 7.6 on Ubuntu 18.04' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(version: '18.04').converge(described_recipe)
      end

      it 'should not have RhostsRSAAuthentication and RSAAuthentication' do
        expect(chef_run).to_not render_file('/etc/ssh/ssh_config').with_content(/RhostsRSAAuthentication/)
        expect(chef_run).to_not render_file('/etc/ssh/ssh_config').with_content(/RSAAuthentication/)
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
