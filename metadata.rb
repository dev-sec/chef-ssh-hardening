# encoding: utf-8
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

name             "ssh-hardening"
maintainer       "Dominik Richter"
maintainer_email "dominik.richter@googlemail.com"
license          "Apache 2.0"
description      "This cookbook installs and provides secure ssh and sshd configurations."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.2.0"

recipe 'ssh-hardening::default', 'installs and configures ssh client and server'
recipe 'ssh-hardening::client', 'install and apply security hardening for ssh client'
recipe 'ssh-hardening::server', 'install and apply security hardening for ssh server'
