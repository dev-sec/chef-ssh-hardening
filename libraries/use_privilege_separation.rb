# encoding: utf-8
#
# Cookbook Name:: ssh-hardening
# Library:: use_privilege_separation
#
# Copyright 2015, Dominik Richter
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
    class UsePrivilegeSeparation
      def self.get(node)
        # define cipher set
        ps53 = 'yes'
        ps59 = 'sandbox'
        ps = ps59

        # ubuntu 12.04 and newer has ssh 5.9+

        # redhat/centos/oracle 6.x has ssh 5.3
        if node['platform_family'] == 'rhel'
          ps = ps53

        # debian 7.x and newer has ssh 5.9+
        elsif node['platform'] == 'debian' && node['platform_version'].to_f <= 6
          ps = ps53
        end

        Chef::Log.info("UsePrivilegeSeparation: #{ps}")
        ps
      end
    end
  end
end
