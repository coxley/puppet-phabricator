require 'rake'
require 'rspec/core/rake_task'

default_platform = 'saucy'

desc "Start VM and run all tests in it (will not destroy VM)"
task :spec, [:platform] do |t, args|
    args.with_defaults(:platform => default_platform)
    system('vagrant', 'up', args.platform) || exit($?.exitstatus)
    system('vagrant', 'ssh', args.platform, '-c', <<-EOS) || exit($?.exitstatus)
      set -e -x
      export PATH="/opt/ruby/bin:$PATH"
      cd /vagrant
      bundle exec rake spec:unit spec:localhost
    EOS
end


namespace :spec do
    desc "Run all tests in a fresh VM, and destroy it when done"
    task :clean, [:platform] do |t, args|
        args.with_defaults(:platform => default_platform)

        # destroy a running VM, if one exists, so we are sure to be running
        # tests on a fresh VM.
        system('vagrant', 'destroy', '-f', args.platform)
        begin
            Rake::Task[:spec].invoke(args.platform)
        ensure
            system('vagrant', 'destroy', '-f', args.platform)
        end
    end

    desc "Run tests on the local host (will run manifests: invoke from a VM)"
    RSpec::Core::RakeTask.new(:localhost) do |t|
        t.pattern = 'spec/localhost/*_spec.rb'
    end

    desc "Run rspec-puppet unit tests"
    RSpec::Core::RakeTask.new(:unit) do |t|
	t.pattern = 'spec/classes/*_spec.rb'
    end
end


task :default => :spec
