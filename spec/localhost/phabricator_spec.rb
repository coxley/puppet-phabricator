require 'spec_helper'


def command_error_message(subject)
    <<-EOS
    #{subject} exited with status #{subject.exit_status}.

    stdout:
    #{subject.stdout}

    stderr:
    #{subject.stderr}
    EOS
end


shared_examples 'a well-behaved manifest' do
    it 'runs without failures' do
        expect(subject.stdout).to_not match /^Error:/i
        expect(subject.exit_status & ~2).to eq(0), command_error_message(subject)
        # invaluable for understanding what went wrong later.
        $stdout.write subject.stdout
    end

    it 'runs without warnings' do
        expect(subject.stdout).to_not match /^Warning:/i
    end
end


describe 'provisioning' do
    puppet_apply = 'sudo puppet apply --detailed-exitcodes -e "include phabricator"'
    describe command(puppet_apply) do
        include_examples 'a well-behaved manifest'
    end

    describe command(puppet_apply) do
        it 'is idempotent' do
	    # phabricator::configure isn't idempotent. Need to fix that.
            todo { expect(subject.exit_status).to eq(0), command_error_message(subject) }
        end
    end
end


describe 'validating' do
    describe port(80) do
        it { should be_listening }
    end

    describe command('wget -q -O - http://127.0.0.1:80/status/') do
        its(:stdout) { should == "ALIVE\n" }
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

    describe command('arc help') do
        it { should return_exit_status 0 }
        its(:stdout) { should_not match /need to install|missing/ }
    end

    describe service('phabricator') do
        it { should be_running }
    end

    describe command('sudo /etc/init.d/phabricator status') do
        its(:exit_status) { should eq(0), command_error_message(subject) }
    end
end
