Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-server-12042-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision "shell", inline: <<-EOS
    apt-get -qq update
    apt-get install -y git
    /opt/ruby/bin/gem install --no-ri --no-rdoc librarian-puppet
    mkdir -p /usr/share/puppet/modules
    ln -s /vagrant /usr/share/puppet/modules/phabricator
    (cd /usr/share/puppet/modules/phabricator && /opt/ruby/bin/librarian-puppet install --path /usr/share/puppet/modules)
  EOS

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "vagrant"
    puppet.manifest_file = "init.pp"
  end
end
