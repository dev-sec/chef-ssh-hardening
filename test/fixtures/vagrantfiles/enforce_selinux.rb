Vagrant.configure(2) do |config|
  config.vm.provision 'shell', inline: <<-SHELL
    yum -y update selinux-* # there are sometimes issues because of old selinux policy in the box
    setenforce 1
  SHELL
end
