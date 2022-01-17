#
# Copyright:: 2014, Deutsche Telekom AG
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

name             'ssh-hardening'
maintainer       'Dominik Richter'
maintainer_email 'dominik.richter@googlemail.com'
license          'Apache-2.0'
description      'This cookbook installs and provides secure ssh and sshd configurations.'
version          '2.9.0'

chef_version '>= 12.5'

supports 'ubuntu', '>= 12.04'
supports 'debian', '>= 6.0'
supports 'centos', '>= 5.0'
supports 'redhat', '>= 5.0'
supports 'oracle', '>= 6.4'
supports 'fedora', '>= 23.0'
supports 'suse'
supports 'opensuse', '>= 13.2'
supports 'opensuseleap', '>= 42.1'
supports 'amazon'

source_url 'https://github.com/dev-sec/chef-ssh-hardening'
issues_url 'https://github.com/dev-sec/chef-ssh-hardening/issues'
