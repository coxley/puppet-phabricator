require 'spec_helper'

describe 'provisioning' do
    describe command('sudo puppet apply --detailed-exitcodes -e "include phabricator"') do
        it 'runs without failures' do
            expect(subject.exit_status & 4).to be == 0
            expect(subject.stdout).to_not match /fail|error/i
        end

        it 'runs without warnings' do
            expect(subject.stdout).to_not match /warning/i
        end
    end

    describe command('sudo puppet apply --detailed-exitcodes -e "include phabricator"') do
        it 'is idempotent' do
            expect(subject.exit_status & 2).to be == 0
        end
    end
end

describe 'validating' do
    describe port(80) do
        it { should be_listening }
    end
end
