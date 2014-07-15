# encoding: utf-8
#
# Cookbook Name:: ssh-hardening
# Recipe:: unlock
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

# This recipe is only used internally for tests. Do not
# rely on it (for the time being)

# workaround for unlocking user accounts:
# Locked user accounts are identified via '!' in /etc/shadow
# SSH will deny login to locked accounts, unless UsePAM is active
# To keep UsePAM dactivated, user accounts are 'unlocked',
# but still get an impossible password - so the aim of locking
# is still present, while SSH login is possible.

execute 'unlock users' do
  command "/bin/sed 's/^\\([^:]*:\\)\\!/\\1*/' -i /etc/shadow"
end
