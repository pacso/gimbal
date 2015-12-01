require 'bundler/setup'

Bundler.require(:default, :test)

require (Pathname.new(__FILE__).dirname + '../lib/gimbal').expand_path

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include GimbalTestHelpers

  config.before(:all) do
    add_fakes_to_path
    create_tmp_directory
  end

  config.before(:each) do
    FakeGithub.clear!
  end
end
