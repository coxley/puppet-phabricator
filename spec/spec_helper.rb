require 'rubygems'
require 'serverspec'
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

  c.color_enabled = true
  c.formatter = :documentation
end
