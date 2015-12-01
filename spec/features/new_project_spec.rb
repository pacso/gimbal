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

  it "creates .ruby-version from Gimbal .ruby-version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end
end
