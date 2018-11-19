control 'sshd configuration should not have any deprecations' do
  describe command('sshd -t') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should eq '' }
    its(:stderr) { should eq '' }
  end
end
