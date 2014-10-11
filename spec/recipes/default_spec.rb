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

require_relative '../spec_helper'

describe 'ssh-hardening::default' do

  # converge
  cached(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  # check that the recipes are executed
  it 'default should include ssh-hardening recipes for server and client' do
    ChefSpec::Server.create_data_bag(
      'users',
      'root' => {
        'id' => 'root',
        'ssh_rootkeys' => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSBlQNUoWqzhOcsyJczKWtA8b2iSKYPl+KcuHlFmrroA6OVu5LrwS3PTy5Ff4d7B4KW0A85StqwtGv9GGnTdI2urCl4eS4PUJifV1pTBh9BWMyStnZoXEy+com5YLcmMBcuDZAwfI9OnPAbfozA1/WB5CP+eXeVuniLoL90U2+xc3KjRyfvCSnK2e6v5K7lYbvmGKUBskG0EYtpX6i9/oiCvaVFLKE5s/Xk9NGjuz0QQPylFFZ9npqKzqmfotEAMbDQxMrNV2ML//9ezVVFWBjI+zyty5QYmhr/bnY7vSqNpGw+czSTGvu3w0z9i2hnVle2WeW0TCkLUNqcu32LM7BCDpXhcsWAGL/ARp0ls8YfPk4nx6mb2Kz877AzhsX0QsiGFtgbcKPMHwdkfeHkBpcEI0X3H9pfA5V9mIqrIZ3bfcV7U0fuwqgAzvfoZYBbBkYiwOhJleW4zg7vIRbFCr5hH7zJmu0fId8ceCnPqX5tXN6qupf/FODaSox/PV/RiMrBHFV2U4/hy8DRKWfifccH9YwwXvl6mLkwz0kbRc6fOf+zdkUS31ip9trUQNjjg2AweNKpG3hN8PAGeGIiEjHlrhRJ4jKJvc4LxupDkuZlBgiNBUxJwf4EYhDC81vqfKgSil9GfTncEW9I/P5rE1qRFtcfdwJFrU4i8/kHN2u8Q== root@bt'
      }
    )

    chef_run.should include_recipe 'ssh-hardening::server'
    chef_run.should include_recipe 'ssh-hardening::client'
  end

end
