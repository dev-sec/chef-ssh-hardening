require 'spec_helper'

RSpec.configure do |c|
    c.filter_run_excluding :skipOn => backend(Serverspec::Commands::Base).check_os[:family]
end

describe 'SSH owner, group and permissions' do

	describe file('/etc/ssh') do
  		it { should be_directory }
	end

    describe file('/etc/ssh') do
      it { should be_owned_by 'root' }
    end

    describe file('/etc/ssh') do
      it { should be_mode 555 }
    end

    describe file('/etc/ssh/sshd_config') do
      it { should be_owned_by 'root' }
    end

    describe file('/etc/ssh/sshd_config') do
      it { should be_mode 400 }
    end

    describe file('/etc/ssh/ssh_config') do
      it { should be_mode 444 }
    end

end
