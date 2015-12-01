require 'spec_helper'

RSpec.describe "Create a new project with default config" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_gimbal
  end

  it 'ensures project specs pass' do
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include('0 failures')
      end
    end
  end

  it "configs missing assets to raise in test" do
    test_config = IO.read("#{project_path}/config/environments/test.rb")

    expect(test_config).to match(
                               /^ +config.assets.raise_runtime_errors = true$/,
                           )
  end

  it "configs raise_on_delivery errors in development" do
    dev_config = IO.read("#{project_path}/config/environments/development.rb")

    expect(dev_config).to match(
                              /^ +config.action_mailer.raise_delivery_errors = true$/,
                          )
  end

  it "adds support file for action mailer" do
    expect(File).to exist("#{project_path}/spec/support/action_mailer.rb")
  end

  it "adds support file for factory girl" do
    expect(File).to exist("#{project_path}/spec/support/factory_girl.rb")
  end

  it "adds support file for database cleaner" do
    expect(File).to exist("#{project_path}/spec/support/database_cleaner.rb")
  end

  it "adds support file for database cleaner" do
    expect(File).to exist("#{project_path}/spec/support/shoulda_matchers.rb")
  end

  it "creates .ruby-version from Gimbal .ruby-version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end
end
