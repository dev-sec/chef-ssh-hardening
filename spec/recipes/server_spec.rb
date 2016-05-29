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
    expect(chef_run).to create_template('/etc/ssh/sshd_config').
      with(mode: '0600').
      with(owner: 'root').
      with(group: 'root')
  end

  it 'enables the ssh server' do
    expect(chef_run).to enable_service('sshd')
  end

  it 'starts the server' do
    expect(chef_run).to start_service('sshd')
  end

  it 'creates the directory /etc/ssh' do
    expect(chef_run).to create_directory('/etc/ssh').
      with(mode: '0755').
      with(owner: 'root').
      with(group: 'root')
  end

  it 'disables weak hmacs' do
    expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
      with_content(/MACs [^#]*\bhmac-sha1\b/)
  end

  it 'disables weak kexs' do
    expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
      with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group14-sha1\b/)
    expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
      with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group-exchange-sha1\b/)
    expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
      with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
  end

  it 'disables cbc ciphers' do
    expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
      with_content(/Ciphers [^#]*-cbc\b/)
  end

  it 'enables ctr ciphers' do
    expect(chef_run).to render_file('/etc/ssh/sshd_config').
      with_content(/Ciphers [^#]*\baes128-ctr\b/).
      with_content(/Ciphers [^#]*\baes192-ctr\b/).
      with_content(/Ciphers [^#]*\baes256-ctr\b/)
  end

  context 'with weak hmacs enabled for the server' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['server']['weak_hmac'] = true
      end.converge(described_recipe)
    end

    it 'allows weak hmacs' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/MACs [^#]*\bhmac-sha1\b/)
    end

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_hmac_server')
    end
  end

  context 'with weak hmacs enabled for only the client' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node, server|
        node.set['ssh']['server']['client']['weak_hmac'] = true
        server.create_data_bag('users', 'someuser' => { id: 'someuser' })
      end.converge(described_recipe)
    end

    it 'weak hmacs on the server are not enabled' do
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
        with_content(/MACs [^#]*\bhmac-sha1\b/)
    end
  end

  context 'weak_kex enabled for only the server' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['server']['weak_kex'] = true
      end.converge(described_recipe)
    end

    it 'enables weak kexs on the server' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group14-sha1\b/)
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group-exchange-sha1\b/)
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_kex_server')
    end
  end

  context 'weak_kex enabled for only the client' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node, server|
        node.set['ssh']['client']['weak_kex'] = true
        server.create_data_bag('users', 'someuser' => { id: 'someuser' })
      end.converge(described_recipe)
    end

    it 'does not enable weak kexs on the server' do
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
        with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group14-sha1\b/)
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
        with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group-exchange-sha1\b/)
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
        with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
    end
  end

  context 'cbc_required for the server only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['ssh']['server']['cbc_required'] = true
      end.converge(described_recipe)
    end

    it 'enables cbc ciphers for the server' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/Ciphers [^#]*\baes256-cbc\b/).
        with_content(/Ciphers [^#]*\baes192-cbc\b/).
        with_content(/Ciphers [^#]*\baes128-cbc\b/)
    end

    it 'does not warn about depreciation' do
      expect(chef_run).not_to write_log('deprecated-ssh/weak_kex_server')
    end
  end

  context 'cbc_required for the client only' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node, server|
        node.set['ssh']['client']['cbc_required'] = true
        server.create_data_bag('users', 'someuser' => { id: 'someuser' })
      end.converge(described_recipe)
    end

    it 'does not enable cbc ciphers for the server' do
      expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
        with_content(/Ciphers [^#]*\b.*-cbc\b/)
    end
  end

  describe 'backward compatibility' do
    context 'legacy attribute weak hmac set' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new do |node, server|
          server.create_data_bag('users', 'someuser' => { id: 'someuser' })
          node.set['ssh']['weak_hmac'] = true
        end.converge(described_recipe)
      end

      it 'allows weak hmacs' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content(/MACs [^#]*\bhmac-sha1\b/)
      end

      it 'still does not allow weak kexs' do
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group14-sha1\b/)
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group-exchange-sha1\b/)
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
      end

      it 'still does not allow cbc ciphers' do
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/Ciphers [^#]*-cbc\b/)
      end

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/weak_hmac_server').
          with(message: /deprecated/).
          with(level: :warn)
      end
    end

    context 'legacy attribute weak_kex set' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new do |node, server|
          node.set['ssh']['weak_kex'] = true
          server.create_data_bag('users', 'someuser' => { id: 'someuser' })
        end.converge(described_recipe)
      end

      it 'allows weak kexs' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group14-sha1\b/)
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group-exchange-sha1\b/)
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
      end

      it 'still does not allow weak macs' do
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/MACs [^#]*\bhmac-sha1\b/)
      end

      it 'still does not allow cbc ciphers' do
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/Ciphers [^#]*-cbc\b/)
      end

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/weak_kex_server').
          with(message: /deprecated/).
          with(level: :warn)
      end
    end

    context 'legacy attribute cbc_required set' do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new do |node, server|
          node.set['ssh']['cbc_required'] = true
          server.create_data_bag('users', 'someuser' => { id: 'someuser' })
        end.converge(described_recipe)
      end

      it 'allows cbc ciphers' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content(/Ciphers [^#]*\baes256-cbc\b/).
          with_content(/Ciphers [^#]*\baes192-cbc\b/).
          with_content(/Ciphers [^#]*\baes128-cbc\b/)
      end

      it 'still does not allow weak macs' do
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/MACs [^#]*\bhmac-sha1\b/)
      end

      it 'still does not allow weak kexs' do
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group14-sha1\b/)
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group-exchange-sha1\b/)
        expect(chef_run).not_to render_file('/etc/ssh/sshd_config').
          with_content(/KexAlgorithms [^#]*\bdiffie-hellman-group1-sha1\b/)
      end

      it 'still enables ctr ciphers' do
        expect(chef_run).to render_file('/etc/ssh/sshd_config').
          with_content(/Ciphers [^#]*\baes128-ctr\b/).
          with_content(/Ciphers [^#]*\baes192-ctr\b/).
          with_content(/Ciphers [^#]*\baes256-ctr\b/)
      end

      it 'warns about depreciation' do
        expect(chef_run).to write_log('deprecated-ssh/cbc_required_server').
          with(message: /deprecated/).
          with(level: :warn)
      end
    end

    %w(weak_hmac weak_kex cbc_required).each do |attr|
      describe "transition logic for #{attr}" do
        context "global #{attr} true, client true and server false" do
          # don't use cache, log persists
          let(:chef_run) do
            ChefSpec::ServerRunner.new do |node, server|
              node.set['ssh'][attr] = true
              node.set['ssh']['client'][attr] = true
              node.set['ssh']['server'][attr] = false
              server.create_data_bag('users', 'someuser' => { id: 'someuser' })
            end.converge(described_recipe)
          end

          it "warns about ignoring the global #{attr} value for the server" do
            expect(chef_run).to write_log("ignored-ssh/#{attr}_server").
              with(message: "Ignoring ssh/#{attr}:true for server").
              with(level: :warn)
          end
        end

        context "global #{attr} true, client false and server true" do
          # don't use cache, log persists
          let(:chef_run) do
            ChefSpec::ServerRunner.new do |node, server|
              node.set['ssh'][attr] = true
              node.set['ssh']['client'][attr] = false
              node.set['ssh']['server'][attr] = true
              server.create_data_bag('users', 'someuser' => { id: 'someuser' })
            end.converge(described_recipe)
          end

          it "does not warn about ignoring the global #{attr}" do
            expect(chef_run).not_to write_log("ignored-ssh/#{attr}_server").
              with_level(:warn)
          end
        end
      end
    end
  end

  it 'restarts the ssh server on config changes' do
    resource = chef_run.template('/etc/ssh/sshd_config')
    expect(resource).to notify('service[sshd]').to(:restart).delayed
  end

  it 'creates .ssh directory for user root' do
    expect(chef_run).to create_directory('/root/.ssh').
      with(mode: '0500').
      with(owner: 'root').
      with(group: 'root')
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
      expect(chef_run).to run_execute('unlock root account if it is locked').
        with(command: "sed 's/^root:\!/root:*/' /etc/shadow -i")
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
      expect(chef_run).to create_template('/root/.ssh/authorized_keys').
        with(mode: '0400').
        with(owner: 'root').
        with(group: 'root')
    end

    it 'authorizes keys from the user data bag for root access' do
      expect(chef_run).to render_file('/root/.ssh/authorized_keys').
        with_content(/^key-user1$/).
        with_content(/^key-user2$/).
        with_content(/^key1-user3$/).
        with_content(/^key2-user3$/).
        with_content(/^key1-user4$/)
    end

    it 'warns about deprecation of data bag use' do
      expect(chef_run).to write_log('deprecated-databag').
        with(message: /deprecated/).
        with(level: :warn)
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

    it 'does not warn about deprecation of data bag use' do
      expect(chef_run).not_to write_log('deprecated-databag')
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
        node.set['ssh']['deny_users'] = %w(someuser)
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
        node.set['ssh']['deny_users'] = %w(someuser otheruser)
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
        node.set['ssh']['use_dns'] = false
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
        node.set['ssh']['use_dns'] = true
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
        node.set['ssh']['sftp']['enable'] = true
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
        node.set['ssh']['sftp']['enable'] = true
        node.set['ssh']['sftp']['group'] = 'testgroup'
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
        node.set['ssh']['sftp']['enable'] = true
        node.set['ssh']['sftp']['chroot'] = 'test_home_dir'
      end.converge(described_recipe)
    end

    it 'sets the SFTP chroot correctly' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').
        with_content(/^ChrootDirectory test_home_dir$/)
    end
  end

end
