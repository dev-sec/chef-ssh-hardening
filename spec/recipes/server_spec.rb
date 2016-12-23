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

describe 'ssh-hardening::server' do
  let(:helper_lib) { DevSec::Ssh }
  let(:ssh_config_file) { '/etc/ssh/sshd_config' }

  # converge
  cached(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  it 'installs openssh-server' do
    expect(chef_run).to install_package('openssh-server')
  end

  it 'creates /etc/ssh/sshd_config' do
    expect(chef_run).to create_template('/etc/ssh/sshd_config').with(
      mode: '0600',
      owner: 'root',
      group: 'root'
    )
  end

  it 'enables the ssh server' do
    expect(chef_run).to enable_service('sshd')
  end

  it 'starts the server' do
    expect(chef_run).to start_service('sshd')
  end

  it 'creates the directory /etc/ssh' do
    expect(chef_run).to create_directory('/etc/ssh').with(
      mode: '0755',
      owner: 'root',
      group: 'root'
    )
  end

  include_examples 'does not allow weak hmacs'
  include_examples 'does not allow weak kexs'
  include_examples 'does not allow weak ciphers'
  include_examples 'allow ctr ciphers'

  context 'with weak hmacs enabled for the server' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak hmacs'
  end

  context 'with weak hmacs enabled for only the client' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['client']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak hmacs'
  end

  context 'weak_kex enabled for only the server' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak kexs'
  end

  context 'weak_kex enabled for only the client' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak kexs'
  end

  context 'cbc_required for the server only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak ciphers'
  end

  context 'cbc_required for the client only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak ciphers'
  end

  context 'with custom KEXs' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['kex'] = 'mycustomkexvalue'
      end.converge(described_recipe)
    end

    it 'uses the value of kex attribute' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/KexAlgorithms mycustomkexvalue/)
    end
  end

  context 'with custom MACs' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['mac'] = 'mycustommacvalue'
      end.converge(described_recipe)
    end

    it 'uses the value of mac attribute' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/MACs mycustommacvalue/)
    end
  end

  context 'with custom ciphers' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['cipher'] = 'mycustomciphervalue'
      end.converge(described_recipe)
    end

    it 'uses the value of cipher attribute' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/Ciphers mycustomciphervalue/)
    end
  end

  it 'restarts the ssh server on config changes' do
    resource = chef_run.template('/etc/ssh/sshd_config')
    expect(resource).to notify('service[sshd]').to(:restart).delayed
  end

  context 'without attribute allow_root_with_key' do
    it 'does not unlock root account' do
      expect(chef_run).to_not run_execute('unlock root account if it is locked')
    end
  end

  context 'with attribute allow_root_with_key' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['allow_root_with_key'] = true
      end.converge(described_recipe)
    end

    it 'unlocks root account' do
      expect(chef_run).to run_execute('unlock root account if it is locked').
        with(command: "sed 's/^root:\!/root:*/' /etc/shadow -i")
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

  it 'disables the login banner' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content(/Banner none/)
  end

  context 'with provided login banner path' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['banner'] = '/etc/ssh/banner'
      end.converge(described_recipe)
    end

    it 'uses the given login banner' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/Banner \/etc\/ssh\/banner/)
    end
  end

  describe 'debian banner' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
    end

    it 'disables the debian banner' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/DebianBanner no/)
    end

    context 'with enabled debian banner' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
          node.normal['ssh-hardening']['ssh']['server']['os_banner'] = true
        end.converge(described_recipe)
      end

      it 'uses the enabled debian banner' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content(/DebianBanner yes/)
      end
    end

    context 'with centos as platform' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511') do |node|
          node.normal['ssh-hardening']['ssh']['server']['os_banner'] = true
        end.converge(described_recipe)
      end

      it 'does not have the debian banner option' do
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/DebianBanner/)
      end
    end
  end

  it 'disables the challenge response authentication' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content(/ChallengeResponseAuthentication no/)
  end

  context 'with challenge response authentication enabled' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['challenge_response_authentication'] = true
      end.converge(described_recipe)
    end

    it 'enables the challenge response authentication' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/ChallengeResponseAuthentication yes/)
    end
  end

  it 'leaves deny users commented' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content(/#DenyUsers */)
  end

  it 'leaves allow users commented' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content(/#AllowUsers user1/)
  end

  it 'leaves deny groups commented' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content(/#DenyGroups */)
  end

  it 'leaves allow groups commented' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content(/#AllowGroups group1/)
  end

  context 'with attribute deny_users' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['deny_users'] = %w(someuser)
      end.converge(described_recipe)
    end

    it 'adds user to deny list' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/DenyUsers [^#]*\bsomeuser\b/)
    end
  end

  context 'with attribute deny_users mutiple' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['deny_users'] = %w(someuser otheruser)
      end.converge(described_recipe)
    end

    it 'adds users to deny list' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/DenyUsers [^#]*\bsomeuser otheruser\b/)
    end
  end

  context 'without attribute use_dns' do
    it 'leaves UseDNS commented' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/#UseDNS no/)
    end
  end

  context 'with attribute use_dns set to false' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['use_dns'] = false
      end.converge(described_recipe)
    end

    it 'sets UseDNS correctly' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/UseDNS no/)
    end
  end

  context 'with attribute use_dns set to true' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['use_dns'] = true
      end.converge(described_recipe)
    end

    it 'sets UseDNS correctly' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/UseDNS yes/)
    end
  end

  context 'without attribute ["sftp"]["enable"]' do
    it 'leaves SFTP Subsystem commented' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/^#Subsystem sftp/)
    end
  end

  context 'with attribute ["sftp"]["enable"] set to true' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['sftp']['enable'] = true
      end.converge(described_recipe)
    end

    it 'sets SFTP Subsystem correctly' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/^Subsystem sftp/)
    end
  end

  context 'with attribute ["sftp"]["enable"] set to true and ["sftp"]["group"] set to "testgroup"' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['sftp']['enable'] = true
        node.normal['ssh-hardening']['ssh']['server']['sftp']['group'] = 'testgroup'
      end.converge(described_recipe)
    end

    it 'sets the SFTP Group correctly' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/^Match Group testgroup$/)
    end
  end

  context 'with attribute ["sftp"]["enable"] set to true and ["sftp"]["chroot"] set to "/export/home/%u"' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['sftp']['enable'] = true
        node.normal['ssh-hardening']['ssh']['server']['sftp']['chroot'] = 'test_home_dir'
      end.converge(described_recipe)
    end

    it 'sets the SFTP chroot correctly' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/^ChrootDirectory test_home_dir$/)
    end
  end
end
