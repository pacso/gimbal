# require 'spec_helper'
#
# RSpec.describe "GitHub" do
#   before do
#     drop_dummy_database
#     remove_project_directory
#   end
#
#   it "creates a project with --github option" do
#     repo_name = 'test'
#     run_gimbal("--github=#{repo_name}")
#     setup_app_dependencies
#
#     expect(FakeGithub).to have_created_repo(repo_name)
#   end
# end
