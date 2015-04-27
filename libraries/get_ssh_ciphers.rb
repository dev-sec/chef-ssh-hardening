# encoding: utf-8
#
# Cookbook Name:: ssh-hardening
# Library:: get_ssh_ciphers
#
# Copyright 2012, Dominik Richter
# Copyright 2014, Christoph Hartmann
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

class Chef
  class Recipe
    class SshCipher
      def self.get_ciphers(node, cbc_required)
        weak_ciphers = cbc_required ? 'weak' : 'default'

        # define cipher set
        ciphers_53 = {}
        ciphers_53.default = 'aes256-ctr,aes192-ctr,aes128-ctr'
        ciphers_53['weak'] = ciphers_53['default'] + ',aes256-cbc,aes192-cbc,aes128-cbc'

        ciphers_66 = {}
        ciphers_66.default = 'chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr'
        ciphers_66['weak'] = ciphers_66['default'] + ',aes256-cbc,aes192-cbc,aes128-cbc'

        # determine the cipher for the operating system
        cipher = ciphers_53

        # use newer ciphers on ubuntu
        if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 14.04
          Chef::Log.info('Detected Ubuntu 14.04 or newer, use new ciphers')
          cipher = ciphers_66

        elsif node['platform'] == 'debian' && node['platform_version'].to_f >= 8
          Chef::Log.info('Detected Debian 8 or newer, use new ciphers')
          cipher = ciphers_66
        end

        Chef::Log.info("Choose cipher: #{cipher[weak_ciphers]}")
        cipher[weak_ciphers]
      end
    end
  end
end
