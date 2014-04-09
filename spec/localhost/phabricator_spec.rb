require 'spec_helper'

describe 'provisioning' do
    describe command('sudo puppet apply --detailed-exitcodes -e "include phabricator"') do
        it 'runs without failures' do
            expect(subject.stdout).to_not match /^Error:/i
            expect(subject.exit_status & ~2).to eq(0), <<-EOS
Puppet exited with status #{subject.exit_status}.

stdout:
#{subject.stdout}

stderr:
#{subject.stderr}
            EOS

            # invaluable for understanding what went wrong later.
            $stdout.write subject.stdout
        end

        it 'runs without warnings' do
            expect(subject.stdout).to_not match /^Warning:/i
        end
    end

    describe command('sudo puppet apply --detailed-exitcodes -e "include phabricator"') do
        it 'is idempotent' do
            expect(subject.exit_status).to eq(0), <<-EOS
Puppet exited with status #{subject.exit_status}.

stdout:
#{subject.stdout}

stderr:
#{subject.stderr}
            EOS
        end
    end
end

describe 'validating' do
    describe port(80) do
        it { should be_listening }
    end

    # php-apc requires phpapi-20090626, which is a virtual package provided by
    # php5-fpm and also mod_php. We don't want or need php-fpm because it
    # consumes port 9000 for no good reason.

    describe package('php5-fpm') do
        it { should_not be_installed }
    end

    describe port(9000) do
        it { should_not be_listening }
    end
end
