require 'spec_helper_acceptance'

describe 'phabricator' do
    let :manifest do
	"class { 'phabricator': }"
    end

    it 'should work with no errors' do
	apply_manifest(manifest, :catch_failures => true) do |application|
	    expect(application.stderr).not_to match(/warning/i)
	end
    end

    it 'is idempotent' do
	expect(apply_manifest(manifest, :catch_failures => true).exit_code).to be_zero
    end

    describe port(80) do
        it { should be_listening }
    end
end
