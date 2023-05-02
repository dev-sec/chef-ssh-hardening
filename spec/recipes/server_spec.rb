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
  let(:dh_primes_ok) { true }

  # converge
  cached(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  before do
    stub_command("test $(awk '$5 < 2047 && $5 ~ /^[0-9]+$/ { print $5 }' /etc/ssh/moduli | uniq | wc -c) -eq 0").and_return(dh_primes_ok)
  end

  it 'should create cache directory' do
    expect(chef_run).to create_directory('/tmp/ssh-hardening-file-cache/ssh-hardening')
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

  it 'accepts default locale environment variables' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content('AcceptEnv LANG LC_* LANGUAGE')
  end

  include_examples 'does not allow weak hmacs'
  include_examples 'does not allow weak kexs'
  include_examples 'does not allow weak ciphers'
  include_examples 'allow ctr ciphers'

  context 'with weak hmacs enabled for the server' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak hmacs'
  end

  context 'with weak hmacs enabled for only the client' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['client']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak hmacs'
  end

  context 'weak_kex enabled for only the server' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak kexs'
  end

  context 'weak_kex enabled for only the client' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak kexs'
  end

  context 'cbc_required for the server only' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak ciphers'
  end

  context 'cbc_required for the client only' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['client']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak ciphers'
  end

  context 'with custom KEXs' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
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
      ChefSpec::SoloRunner.new do |node|
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
      ChefSpec::SoloRunner.new do |node|
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
      ChefSpec::SoloRunner.new do |node|
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
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['banner'] = '/etc/ssh/banner'
      end.converge(described_recipe)
    end

    it 'uses the given login banner' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/Banner \/etc\/ssh\/banner/)
    end
  end

  describe 'permit_tunnel options' do
    let(:permit_tunnel) { false }

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['permit_tunnel'] = permit_tunnel
      end.converge(described_recipe)
    end

    context 'with default value of false' do
      it 'should set PermitTunnel to no' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('PermitTunnel no')
      end
    end

    context 'with value of true' do
      let(:permit_tunnel) { true }
      it 'should set PermitTunnel to yes' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('PermitTunnel yes')
      end
    end

    context 'with a valid string' do
      let(:permit_tunnel) { 'ethernet' }
      it 'should set PermitTunnel to ethernet' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('PermitTunnel ethernet')
      end
    end
  end

  it 'should set UsePAM to yes per default' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('UsePAM yes')
  end

  describe 'version specific options' do
    context 'running with OpenSSH < 7.4' do
      it 'should have UseLogin' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('UseLogin')
      end

      it 'should have UsePrivilegeSeparation' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('UsePrivilegeSeparation')
      end
    end

    context 'running with OpenSSH >= 7.4 on RHEL 7' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '7.5.1804').converge(described_recipe)
      end

      before do
        stub_command('getenforce | grep -vq Disabled && semodule -l | grep -q ssh_password').and_return(true)
      end

      it 'should not have UseLogin' do
        expect(chef_run).to_not render_file('/etc/ssh/sshd_config').with_content('UseLogin')
      end
    end

    context 'running with Openssh >= 7.5 on Ubuntu 18.04' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(version: '18.04').converge(described_recipe)
      end

      it 'should not have UseLogin' do
        expect(chef_run).to_not render_file('/etc/ssh/sshd_config').with_content('UseLogin')
      end

      it 'should not have UsePrivilegeSeparation' do
        expect(chef_run).to_not render_file('/etc/ssh/sshd_config').with_content('UsePrivilegeSeparation')
      end
    end
  end

  describe 'UsePAM option' do
    let(:use_pam) { true }

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
        node.normal['ssh-hardening']['ssh']['server']['use_pam'] = use_pam
      end.converge(described_recipe)
    end

    context 'when running on Ubuntu' do
      let(:platform) { 'ubuntu' }
      let(:version) { '16.04' }

      it 'does not invoke any SELinux resources' do
        expect(chef_run).not_to render_file('/tmp/ssh-hardening-file-cache/ssh-hardening/ssh_password.te')
        expect(chef_run).not_to run_execute('remove selinux policy')
        expect(chef_run).not_to run_bash('build selinux package and install it')
        expect(chef_run).not_to install_package('policycoreutils-python')
      end

      context 'when use_pam is set to true' do
        let(:use_pam) { true }

        it 'should set UsePAM to yes' do
          expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('UsePAM yes')
        end
      end

      context 'when use_pam is set to false' do
        let(:use_pam) { false }

        it 'should set UsePAM to no' do
          expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('UsePAM no')
        end
      end
    end

    context 'when running on CentOS' do
      let(:platform) { 'centos' }
      let(:version) { '7.5.1804' }

      let(:selinux_disabled_or_policy_removed) { false }
      let(:selinux_enabled_and_policy_installed) { false }

      before do
        stub_command('getenforce | grep -vq Disabled && semodule -l | grep -q ssh_password').and_return(selinux_enabled_and_policy_installed)
        stub_command('getenforce | grep -q Disabled || semodule -l | grep -q ssh_password').and_return(selinux_disabled_or_policy_removed)
      end

      it 'should install selinux tools' do
        expect(chef_run).to install_package('policycoreutils-python')
      end

      context 'when use_pam is set to true' do
        let(:use_pam) { true }

        it 'should set UsePAM to yes' do
          expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('UsePAM yes')
        end

        context 'when selinux is disabled or policy is removed' do
          let(:selinux_enabled_and_policy_installed) { false }

          it 'should not invoke the policy removal' do
            expect(chef_run).not_to run_execute('remove selinux policy')
          end
        end

        context 'when selinux is enabled and policy is present' do
          let(:selinux_enabled_and_policy_installed) { true }

          it 'should invoke the policy removal' do
            expect(chef_run).to run_execute('remove selinux policy')
          end
        end
      end

      context 'when use_pam is set to false' do
        let(:use_pam) { false }

        it 'should set UsePAM to no' do
          expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content('UsePAM no')
        end

        it 'should create selinux source policy file' do
          expect(chef_run).to render_file('/tmp/ssh-hardening-file-cache/ssh-hardening/ssh_password.te')
        end

        context 'when selinux is disabled or policy is installed' do
          let(:selinux_disabled_or_policy_removed) { true }

          it 'should not install the policy' do
            expect(chef_run).not_to run_bash('build selinux package and install it')
          end
        end

        context 'when selinux is enabled and policy is not installed' do
          let(:selinux_disabled_or_policy_removed) { false }

          it 'should install the policy' do
            expect(chef_run).to run_bash('build selinux package and install it')
          end
        end
      end
    end
  end

  it 'should not build own DH primes per default' do
    expect(chef_run).not_to run_bash('build own primes for DH')
  end

  describe 'DH primes handling' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    context 'when there are no small primes' do
      let(:dh_primes_ok) { true }

      it 'should not remove small primes from DH moduli' do
        expect(chef_run).not_to run_ruby_block('remove small primes from DH moduli')
      end
    end

    context 'when there are small primes present' do
      let(:dh_primes_ok) { false }

      it 'should invoke small primes from DH module' do
        expect(chef_run).to run_ruby_block('remove small primes from DH moduli')
      end
    end
  end

  describe 'debian banner' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
    end

    it 'disables the debian banner' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/DebianBanner no/)
    end

    context 'with enabled debian banner' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
          node.normal['ssh-hardening']['ssh']['server']['os_banner'] = true
        end.converge(described_recipe)
      end

      it 'uses the enabled debian banner' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content(/DebianBanner yes/)
      end
    end

    context 'with centos as platform' do
      before do
        stub_command('getenforce | grep -vq Disabled && semodule -l | grep -q ssh_password').and_return(true)
      end

      cached(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '7.5.1804') do |node|
          node.normal['ssh-hardening']['ssh']['server']['os_banner'] = true
        end.converge(described_recipe)
      end

      it 'does not have the debian banner option' do
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/DebianBanner/)
      end
    end
  end

  describe 'extra configuration values' do
    context 'without custom extra config value' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new.converge(described_recipe)
      end

      it 'does not have any extra config options' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config')
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/^# Extra Configuration Options/)
      end
    end

    context 'with custom extra config value' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.normal['ssh-hardening']['ssh']['server']['extras']['#ExtraConfig'] = 'Value'
        end.converge(described_recipe)
      end

      it 'uses the extra config attributes' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content(/^# Extra Configuration Options/)
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content(/^#ExtraConfig Value/)
      end
    end
  end

  describe 'match configuration blocks' do
    context 'without custom extra config value' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new.converge(described_recipe)
      end

      it 'does not have any match config blocks' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config')
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/^# Match Configuration Blocks/)
      end
    end

    context 'with custom match config block value' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.normal['ssh-hardening']['ssh']['server']['match_blocks']['User root'] = <<~ROOT
            AuthorizedKeysFile .ssh/authorized_keys
          ROOT
        end.converge(described_recipe)
      end

      it 'uses the match config blocks' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content(/^# Match Configuration Blocks/)
        expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content(/^Match User root/)
      end
    end
  end

  it 'disables the challenge response authentication' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content(/ChallengeResponseAuthentication no/)
  end

  context 'with challenge response authentication enabled' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['challenge_response_authentication'] = true
      end.converge(described_recipe)
    end

    it 'enables the challenge response authentication' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/ChallengeResponseAuthentication yes/)
    end
  end

  it 'sets the login grace time to 30s' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content(/LoginGraceTime 30s/)
  end

  context 'with configured login grace time to 60s' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['login_grace_time'] = '60s'
      end.converge(described_recipe)
    end

    it 'sets the login grace time to 60s' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/LoginGraceTime 60s/)
    end
  end

  it 'sets the log level to verbose' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content('LogLevel VERBOSE')
  end

  context 'with log level set to debug' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['log_level'] = 'debug'
      end.converge(described_recipe)
    end

    it 'sets the log level to debug' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content('LogLevel DEBUG')
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
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['deny_users'] = %w[someuser]
      end.converge(described_recipe)
    end

    it 'adds user to deny list' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/DenyUsers [^#]*\bsomeuser\b/)
    end
  end

  context 'with attribute deny_users mutiple' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['deny_users'] = %w[someuser otheruser]
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
      ChefSpec::SoloRunner.new do |node|
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
      ChefSpec::SoloRunner.new do |node|
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
      ChefSpec::SoloRunner.new do |node|
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
      ChefSpec::SoloRunner.new do |node|
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
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['sftp']['enable'] = true
        node.normal['ssh-hardening']['ssh']['server']['sftp']['chroot'] = 'test_home_dir'
      end.converge(described_recipe)
    end

    it 'sets the SFTP chroot correctly' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/^[[:space:]]*ChrootDirectory test_home_dir$/)
    end
  end

  context 'with disabled IPv6' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['network']['ipv6']['enable'] = false
      end.converge(described_recipe)
    end

    it 'sets proper IPv4 ListenAdress' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/ListenAddress 0.0.0.0/)
    end
  end

  context 'with enabled IPv6' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['network']['ipv6']['enable'] = true
      end.converge(described_recipe)
    end

    it 'sets proper IPv4 and IPv6 ListenAdress' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/ListenAddress 0.0.0.0/).
        with_content(/ListenAddress ::/)
    end
  end

  context 'with empty accept_env attribute' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['accept_env'] = []
      end.converge(described_recipe)
    end

    it 'will not accept any environment variables' do
      expect(chef_run).to_not render_file('/etc/ssh/sshd_config').
        with_content(/AcceptEnv/)
    end
  end

  context 'with custom accept_env attribute' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['ssh-hardening']['ssh']['server']['accept_env'] = %w[some environment variables]
      end.converge(described_recipe)
    end

    it 'uses the value of accept_env attribute' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/AcceptEnv some environment variables/)
    end
  end

  describe 'customized AuthorizedKeysFile option' do
    context 'without customized AuthorizedKeysFile' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new.converge(described_recipe)
      end

      it 'does not have AuthorizedKeysFile configured' do
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/^[[:space:]]*AuthorizedKeysFile/)
      end
    end

    context 'with customized global AuthorizedKeysFile' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.normal['ssh-hardening']['ssh']['server']['authorized_keys_path'] = '/some/authorizedkeysfile'
        end.converge(described_recipe)
      end

      it 'has AuthorizedKeysFile configured' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content('AuthorizedKeysFile /some/authorizedkeysfile')
      end
    end

    context 'with customized sftponly AuthorizedKeysFile' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.normal['ssh-hardening']['ssh']['server']['sftp']['enable'] = true
          node.normal['ssh-hardening']['ssh']['server']['sftp']['authorized_keys_path'] = '/some/authorizedkeysfile'
        end.converge(described_recipe)
      end

      it 'has AuthorizedKeysFile configured' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content('AuthorizedKeysFile /some/authorizedkeysfile')
      end
    end
  end
end
