require 'rubygems'
require 'serverspec'
require 'rspec-puppet'
require 'rspec/todo'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS
include RSpec::Todo

RSpec.configure do |c|
  if ENV['ASK_SUDO_PASSWORD']
    require 'highline/import'
    c.sudo_password = ask("Enter sudo password: ") { |q| q.echo = false }
  else
    c.sudo_password = ENV['SUDO_PASSWORD']
  end

  c.module_path = '/usr/share/puppet/modules'
  c.manifest_dir = '/usr/share/puppet/manifests'
  c.default_facts = {
    :concat_basedir => '/tmp/concat'
  }

  c.color_enabled = true
  c.formatter = :documentation
end
