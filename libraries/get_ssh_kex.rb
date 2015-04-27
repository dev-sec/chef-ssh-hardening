# encoding: utf-8
#
# Cookbook Name:: ssh-hardening
# Library:: get_ssh_kexs
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
    class SshKex
      def self.get_kexs(node, weak_kex)
        weak_kex = weak_kex ? 'weak' : 'default'

        kex_59 = {}
        kex_59.default = 'diffie-hellman-group-exchange-sha256'
        kex_59['weak'] = kex_59['default'] + ',diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'

        kex_66 = {}
        kex_66.default = 'curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256'
        kex_66['weak'] = kex_66['default'] + ',diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'

        # determine the kex for the operating system
        kex = kex_59

        # use newer kex on ubuntu 14.04
        if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 14.04
          Chef::Log.info('Detected Ubuntu 14.04 or newer, use new key exchange algorithms')
          kex = kex_66

        elsif node['platform'] == 'debian' && node['platform_version'].to_f >= 8
          Chef::Log.info('Detected Debian 8 or newer, use new key exchange algorithms')
          kex = kex_66

        # deactivate kex on redhat
        elsif node['platform_family'] == 'rhel'
          kex = {}
          kex.default = nil

        # deactivate kex on debian 6
        elsif node['platform'] == 'debian' && node['platform_version'].to_f <= 6
          Chef::Log.info('Detected Debian 6 or earlier, disable KEX')
          kex = {}
          kex.default = nil
        end

        Chef::Log.info("Choose kex: #{kex[weak_kex]}")
        kex[weak_kex]
      end
    end
  end
end
