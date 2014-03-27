require 'beaker-rspec'

unless ENV['BEAKER_provision'] == 'no'
    hosts.each do |host|
	install_puppet

        if ENV['BEAKER_set'] == 'ubuntu-12042-x64'
            # Ubuntu 12.04 comes with ruby 1.8, where rubygems is a separate
            # package. Ubuntu 13.10 comes with ruby 1.9 which includes
            # rubygems.
            on host, 'apt-get install -y rubygems'
        end

        on host, 'apt-get install -y git ruby-dev'
        on host, 'gem install --no-ri --no-rdoc librarian-puppet'
    end
end

RSpec.configure do |c|
    proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

    # Configure all nodes in nodeset
    c.before :suite do
	puppet_module_install(:source => proj_root, :module_name => 'phabricator')
        hosts.each do |host|
            path = File.join(host['distmoduledir'], 'phabricator')
            on host, "cd '#{path}'; librarian-puppet install --path #{host['distmoduledir']}"
        end
    end
end
