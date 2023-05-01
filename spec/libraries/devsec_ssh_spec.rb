# encoding: utf-8

#
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

# Simple mock for Chef::Log
class Chef
  class Log
    def self.info(*); end

    def self.debug(*); end
  end
end

describe DevSec::Ssh do
  subject { DevSec::Ssh }
  let(:family) { 'debian' }
  let(:platform) { 'ubuntu' }
  let(:version) { '16.04' }
  let(:package_installed) { true }
  let(:package_version) { '1:7.2p2-4ubuntu2.1' }
  let(:package_name) { 'openssh-server' }
  let(:node) do
    node = {
      'platform_family' => family,
      'platform' => platform,
      'platform_version' => version,
      'ssh-hardening' => {
        'sshclient' => {
          'package' => package_name
        },
        'sshserver' => {
          'package' => package_name
        }
      }
    }
    node['packages'] = { package_name => { 'version' => package_version } } if package_installed

    node
  end

  before :each do
    # Stub the node object of Chef
    allow(subject).to receive(:node).and_return(node)
  end

  describe 'guess_ssh_version' do
    context 'when running on Ubuntu 16.04' do
      let(:family) { 'debian' }
      let(:platform) { 'ubuntu' }
      let(:version) { '16.04' }

      it 'should return ssh version 6.6' do
        expect(subject.send(:guess_ssh_version)).to eq 6.6
      end
    end

    context 'when running on Debian 8' do
      let(:family) { 'debian' }
      let(:platform) { 'debian' }
      let(:version) { '8.6' }

      it 'should return ssh version 6.6' do
        expect(subject.send(:guess_ssh_version)).to eq 6.6
      end
    end

    context 'when running on Debian 5' do
      let(:family) { 'debian' }
      let(:platform) { 'debian' }
      let(:version) { '5.0' }

      it 'should return ssh version 5.3' do
        expect(subject.send(:guess_ssh_version)).to eq 5.3
      end
    end

    context 'when running on RHEL 7' do
      let(:family) { 'rhel' }
      let(:platform) { 'centos' }
      let(:version) { '7.2.1511' }

      it 'should return ssh version 6.6' do
        expect(subject.send(:guess_ssh_version)).to eq 6.6
      end
    end

    context 'when running on RHEL 6' do
      let(:family) { 'rhel' }
      let(:platform) { 'centos' }
      let(:version) { '6.8' }

      it 'should return ssh version 5.3' do
        expect(subject.send(:guess_ssh_version)).to eq 5.3
      end
    end

    context 'when running on Fedora 25' do
      let(:family) { 'fedora' }
      let(:platform) { 'fedora' }
      let(:version) { '25' }

      it 'should return ssh version 7.3' do
        expect(subject.send(:guess_ssh_version)).to eq 7.3
      end
    end

    context 'when running on Fedora 24' do
      let(:family) { 'fedora' }
      let(:platform) { 'fedora' }
      let(:version) { '24' }

      it 'should return ssh version 7.2' do
        expect(subject.send(:guess_ssh_version)).to eq 7.2
      end
    end

    context 'when running on Opensuse 13.2' do
      let(:family) { 'suse' }
      let(:platform) { 'opensuse' }
      let(:version) { '13.2' }

      it 'should return ssh version 6.6' do
        expect(subject.send(:guess_ssh_version)).to eq 6.6
      end
    end

    context 'when running on Opensuse 42.2' do
      let(:family) { 'suse' }
      let(:platform) { 'opensuseleap' }
      let(:version) { '42.2' }

      it 'should return ssh version 7.2' do
        expect(subject.send(:guess_ssh_version)).to eq 7.2
      end
    end

    context 'when running on unknown platform' do
      let(:family) { 'unknown' }
      let(:platform) { 'unknown' }
      let(:version) { 'unknown' }

      it 'should return the fallback ssh version' do
        expect(subject.send(:guess_ssh_version)).to eq subject::FALLBACK_SSH_VERSION
      end
    end
  end

  describe 'get_ssh_version' do
    context 'when ssh server package is installed' do
      let(:package_installed) { true }
      let(:package_name) { 'openssh-server' }

      context 'with version 6.6 on rhel system' do
        let(:package_version) { '6.6.1p1' }
        let(:family) { 'rhel' }

        it 'should return the ssh version 6.6' do
          expect(subject.send(:get_ssh_version, package_name)).to eq 6.6
        end
      end

      context 'with version 1:7.2p2-4ubuntu2.1 on debian system' do
        let(:package_version) { '1:7.2p2-4ubuntu2.1' }
        let(:family) { 'debian' }

        it 'should return the ssh version 7.2' do
          expect(subject.send(:get_ssh_version, package_name)).to eq 7.2
        end
      end
    end

    context 'when ssh package is not installed' do
      let(:package_installed) { false }

      it 'should guess the ssh version' do
        expect(subject).to receive(:guess_ssh_version)
        subject.send(:get_ssh_version, package_name)
      end
    end
  end

  describe 'find_ssh_version' do
    context 'when it gets the valid ssh version' do
      it 'should return the next small version' do
        expect(subject.send(:find_ssh_version, 5.7, [5.3, 5.9, 6.6])).to eq 5.3
      end
    end
    context 'when it gets the invalid ssh version' do
      it 'should raise an exception' do
        expect { subject.send(:find_ssh_version, 3.0, [5.3, 5.9, 6.6]) }.to raise_exception(/Unsupported ssh version/)
      end
    end
  end

  describe 'get_server_privilege_separation' do
    DevSec::Ssh::PRIVILEGE_SEPARATION.each do |openssh_version, conf_data|
      context "when openssh is >= #{openssh_version}" do
        before :each do
          # mock get_ssh_server_version. We test it somewhere else
          expect(subject).to receive(:get_ssh_server_version) { openssh_version }
        end

        it "get the config value #{conf_data}" do
          expect(subject.get_server_privilege_separarion).to eq conf_data
        end
      end
    end
    context 'when openssh has a totally unsupported version, e.g. 3.0' do
      it 'should raise an exception' do
        expect(subject).to receive(:get_ssh_server_version) { 3.0 }
        expect { subject.get_server_privilege_separarion }.to raise_exception(/Unsupported ssh version/)
      end
    end
  end

  describe 'get_server_algorithms' do
    DevSec::Ssh::HOSTKEY_ALGORITHMS.each do |openssh_version, conf_data|
      context "when openssh is >= #{openssh_version}" do
        before :each do
          # mock get_ssh_server_version. We test it somewhere else
          expect(subject).to receive(:get_ssh_server_version) { openssh_version }
        end

        it "get the config value #{conf_data}" do
          expect(subject.get_server_algorithms).to eq conf_data
        end
      end
    end
    context 'when openssh has a totally unsupported version, e.g. 3.0' do
      it 'should raise an exception' do
        expect(subject).to receive(:get_ssh_server_version) { 3.0 }
        expect { subject.get_server_algorithms }.to raise_exception(/Unsupported ssh version/)
      end
    end
  end

  # Here we test the public functions:
  # get_[client|server]_[kexs|macs|ciphers]
  # In order to cover all possible combinations, we need a complex nested loops:-\
  # We start with client|server combination
  %w[client server].each do |type|
    # Go over different types of crypto parameters, e.g. kexs, macs, ciphers
    DevSec::Ssh::CRYPTO.each do |crypto_type, crypto_value| # we can not use subject here, as its not in the block
      function = "get_#{type}_#{crypto_type}"

      # here we start to describe a specific function like get_client_kexs
      describe function do
        # Go over different ssh versions
        crypto_value.each do |openssh_version, crypto_params|
          next unless openssh_version.is_a?(Float) # skip :weak

          context "when openssh is >= #{openssh_version}" do
            before :each do
              # mock get_ssh_[client|server]_version. We test it somewhere else
              expect(subject).to receive("get_ssh_#{type}_version") { openssh_version }
            end

            if crypto_params.empty?
              it 'get nil' do
                expect(subject.send(function)).to eq nil
              end
            else
              # Check the different combinations of weak_parameter to the function
              [true, false].each do |weak_option|
                context "and when weak option is #{weak_option}" do
                  let(:ret) { subject.send(function, weak_option).split(',') }

                  it "get crypto parameters #{weak_option ? 'with' : 'without'} weak options" do
                    exp = weak_option ? (crypto_params | crypto_value[:weak]) : crypto_params
                    expect(ret).to eq exp
                  end
                end
              end
            end
          end
        end

        context 'when openssh has a totally unsupported version, e.g. 3.0' do
          it 'should raise an exception' do
            expect(subject).to receive("get_ssh_#{type}_version".to_sym) { 3.0 }
            expect { subject.send(function) }.to raise_exception(/Unsupported ssh version/)
          end
        end
      end
    end
  end

  describe 'get_ssh_server_version' do
    it 'should call get_ssh_version with server package attribute' do
      expect(subject).to receive(:get_ssh_version).with(package_name)
      subject.send(:get_ssh_server_version)
    end
  end

  describe 'get_ssh_client_version' do
    it 'should call get_ssh_version with client package attribute' do
      expect(subject).to receive(:get_ssh_version).with(package_name)
      subject.send(:get_ssh_client_version)
    end
  end

  describe 'validate_permit_tunnel' do
    context 'with value of false' do
      it 'should return no' do
        expect(subject.send(:validate_permit_tunnel, false)).to eq 'no'
      end
    end

    context 'with value of true' do
      it 'should return yes' do
        expect(subject.send(:validate_permit_tunnel, true)).to eq 'yes'
      end
    end

    context 'with a valid string ethernet' do
      it 'should return ethernet' do
        expect(subject.send(:validate_permit_tunnel, 'ethernet')).to eq 'ethernet'
      end
    end

    context 'with an invalid string' do
      it 'should raise exception' do
        expect { subject.send(:validate_permit_tunnel, 'IAmNotValid') }.to raise_exception('Incorrect value for attribute node[\'ssh-hardening\'][\'ssh\'][\'server\'][\'permit_tunnel\']: must be boolean or a string as defined in the sshd_config man pages, you passed "IAmNotValid"')
      end
    end
  end
end
