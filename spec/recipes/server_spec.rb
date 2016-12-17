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
        node.normal['ssh']['server']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak hmacs'

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_hmac_server')
    end
  end

  context 'with weak hmacs enabled for only the client' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['server']['client']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak hmacs'
  end

  context 'weak_kex enabled for only the server' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['server']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak kexs'

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_kex_server')
    end
  end

  context 'weak_kex enabled for only the client' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['client']['weak_kex'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak kexs'
  end

  context 'cbc_required for the server only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['server']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'allow weak ciphers'

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_kex_server')
    end
  end

  context 'cbc_required for the client only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['ssh']['client']['cbc_required'] = true
      end.converge(described_recipe)
    end

    include_examples 'does not allow weak ciphers'
  end

  describe 'backward compatibility' do
    context 'legacy attribute weak hmac set' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new do |node|
          node.normal['ssh']['weak_hmac'] = true
        end.converge(described_recipe)
      end

      include_examples 'allow weak hmacs'
      include_examples 'does not allow weak kexs'
      include_examples 'does not allow weak ciphers'

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/weak_hmac_server').with(
          message: 'ssh/server/weak_hmac set from deprecated ssh/weak_hmac',
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
        expect(chef_run).to write_log('deprecated-ssh/weak_kex_server').with(
          message: 'ssh/server/weak_kex set from deprecated ssh/weak_kex',
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
        expect(chef_run).to write_log('deprecated-ssh/cbc_required_server').with(
          message: 'ssh/server/cbc_required set from deprecated ssh/cbc_required',
          level: :warn
        )
      end
    end

    %w(weak_hmac weak_kex cbc_required).each do |attr|
      describe "transition logic for #{attr}" do
        context "global #{attr} true, client true and server false" do
          # don't use cache, log persists
          let(:chef_run) do
            ChefSpec::ServerRunner.new do |node|
              node.normal['ssh'][attr] = true
              node.normal['ssh']['client'][attr] = true
              node.normal['ssh']['server'][attr] = false
            end.converge(described_recipe)
          end

          it "warns about ignoring the global #{attr} value for the server" do
            expect(chef_run).to write_log("ignored-ssh/#{attr}_server").with(
              message: "Ignoring ssh/#{attr}:true for server",
              level: :warn
            )
          end
        end

        context "global #{attr} true, client false and server true" do
          # don't use cache, log persists
          let(:chef_run) do
            ChefSpec::ServerRunner.new do |node|
              node.normal['ssh'][attr] = true
              node.normal['ssh']['client'][attr] = false
              node.normal['ssh']['server'][attr] = true
            end.converge(described_recipe)
          end

          it "does not warn about ignoring the global #{attr}" do
            expect(chef_run).not_to write_log("ignored-ssh/#{attr}_server").with(
              level: :warn
            )
          end
        end
      end
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
        node.normal['ssh']['allow_root_with_key'] = true
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
        node.normal['ssh']['deny_users'] = %w(someuser)
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
        node.normal['ssh']['deny_users'] = %w(someuser otheruser)
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
        node.normal['ssh']['use_dns'] = false
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
        node.normal['ssh']['use_dns'] = true
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
        node.normal['ssh']['sftp']['enable'] = true
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
        node.normal['ssh']['sftp']['enable'] = true
        node.normal['ssh']['sftp']['group'] = 'testgroup'
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
        node.normal['ssh']['sftp']['enable'] = true
        node.normal['ssh']['sftp']['chroot'] = 'test_home_dir'
      end.converge(described_recipe)
    end

    it 'sets the SFTP chroot correctly' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/^ChrootDirectory test_home_dir$/)
    end
  end
end
