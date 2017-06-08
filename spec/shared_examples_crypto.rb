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

RSpec.shared_examples 'does not allow weak hmacs' do
  it 'should not allow weak hmacs' do
    helper_lib::CRYPTO[:macs][:weak].each do |mac|
      expect(chef_run).not_to render_file(ssh_config_file).
        with_content(/MACs [^#]*\b#{mac}\b/)
    end
  end
end

RSpec.shared_examples 'does not allow weak kexs' do
  it 'should not allow weak kexs' do
    helper_lib::CRYPTO[:kexs][:weak].each do |kex|
      expect(chef_run).not_to render_file(ssh_config_file).
        with_content(/KexAlgorithms [^#]*\b#{kex}\b/)
    end
  end
end

RSpec.shared_examples 'does not allow weak ciphers' do
  it 'should not allow weak ciphers' do
    helper_lib::CRYPTO[:ciphers][:weak].each do |cipher|
      expect(chef_run).not_to render_file(ssh_config_file).
        with_content(/Ciphers [^#]*\b#{cipher}\b/)
    end
  end
end

RSpec.shared_examples 'allow ctr ciphers' do
  let(:ctr_ciphers) { %w[aes256-ctr aes192-ctr aes128-ctr] }
  it 'should allow ctr ciphers' do
    ctr_ciphers.each do |cipher|
      expect(chef_run).to render_file(ssh_config_file).
        with_content(/Ciphers [^#]*\b#{cipher}\b/)
    end
  end
end

RSpec.shared_examples 'allow weak hmacs' do
  it 'should allow weak hmacs' do
    helper_lib::CRYPTO[:macs][:weak].each do |mac|
      expect(chef_run).to render_file(ssh_config_file).
        with_content(/MACs [^#]*\b#{mac}\b/)
    end
  end
end

RSpec.shared_examples 'allow weak kexs' do
  it 'should allow weak kexs' do
    helper_lib::CRYPTO[:kexs][:weak].each do |kex|
      expect(chef_run).to render_file(ssh_config_file).
        with_content(/KexAlgorithms [^#]*\b#{kex}\b/)
    end
  end
end

RSpec.shared_examples 'allow weak ciphers' do
  it 'should allow weak ciphers' do
    helper_lib::CRYPTO[:ciphers][:weak].each do |cipher|
      expect(chef_run).to render_file(ssh_config_file).
        with_content(/Ciphers [^#]*\b#{cipher}\b/)
    end
  end
end
