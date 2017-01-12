describe command('getenforce') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include 'Enforcing' }
  its(:stderr) { should eq '' }
end

describe command('semodule -l | grep "ssh_password"') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should include 'ssh_password' }
  its(:stderr) { should eq '' }
end
