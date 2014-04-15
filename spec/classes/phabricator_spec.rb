require 'spec_helper'

module RSpec::Puppet
  module ManifestMatchers
    class CreateGeneric
      def that_is_anchored()
        self.that_requires('Anchor[phabricator::begin]').that_comes_before('Anchor[phabricator::end]')
      end
    end
  end
end

describe 'phabricator' do
  let(:facts) { {
    :operatingsystem => 'Ubuntu',
    :osfamily => 'Debian',
    :operatingsystemrelease => '12.04',
  } }

  it { should contain_anchor('phabricator::begin') }
  it { should contain_anchor('phabricator::end') }

  describe 'other services' do
    %w{Arcanist Apache Mysql::Server}.each do |name|
      it { should contain_class(name).that_is_anchored }
    end
  end

  describe 'apache modules' do
    %w{
      php
      rewrite
      ssl
    }.each do |name|
      it { should contain_class("Apache::Mod::#{name}").that_is_anchored }
    end
  end

  describe 'PHP extensions' do
    %w{
      php5-curl
      php5-gd
      php5-json
      php5-mysql
      php-apc
    }.each do |name|
      it { should contain_package(name).that_requires('Package[php5-cli]') }
    end
  end
end
