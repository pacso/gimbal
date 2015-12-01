require 'forwardable'

module Gimbal
  class AppBuilder < Rails::AppBuilder
    include Gimbal::Actions
    extend Forwardable

    def replace_gemfile
      remove_file 'Gemfile'
      template 'Gemfile.erb', 'Gemfile'
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{Gimbal::RUBY_VERSION}\n"
    end

    def init_git
      run 'git init'
    end

    def raise_on_missing_assets_in_test
      inject_into_file(
          "config/environments/test.rb",
          "\n  config.assets.raise_runtime_errors = true",
          after: "Rails.application.configure do",
      )
    end

    def raise_on_delivery_errors
      replace_in_file 'config/environments/development.rb',
                      'raise_delivery_errors = false', 'raise_delivery_errors = true'
    end

    def set_dev_mail_delivery_method
      inject_into_file(
          "config/environments/development.rb",
          "\n  config.action_mailer.delivery_method = :letter_opener",
          after: "config.action_mailer.raise_delivery_errors = true",
      )
    end

    def add_bullet_gem_configuration
      config = <<-RUBY
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end

      RUBY

      inject_into_file(
          "config/environments/development.rb",
          config,
          after: "config.action_mailer.delivery_method = :letter_opener\n",
      )
    end

    def raise_on_unpermitted_parameters
      config = <<-RUBY
    config.action_controller.action_on_unpermitted_parameters = :raise
      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    def use_mysql_config_template
      template 'mysql_database.yml.erb', 'config/database.yml', force: true
    end

    def configure_spec_support_features
      empty_directory_with_keep_file 'spec/features'
      empty_directory_with_keep_file 'spec/factories'
      empty_directory_with_keep_file 'spec/support/features'
    end

    def configure_action_mailer_in_specs
      copy_file 'action_mailer.rb', 'spec/support/action_mailer.rb'
    end

    def gitignore_files
      remove_file '.gitignore'
      copy_file 'gimbal_gitignore', '.gitignore'
      %w(app/views/pages spec/lib spec/controllers spec/helpers spec/support/matchers spec/support/mixins spec/support/shared_examples).each do |dir|
        run "mkdir #{dir}"
        run "touch #{dir}/.keep"
      end
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def enable_database_cleaner
      copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
    end

    def set_up_factory_girl_for_rspec
      copy_file 'factory_girl_rspec.rb', 'spec/support/factory_girl.rb'
    end

    def generate_factories_file
      copy_file "factories.rb", "spec/factories.rb"
    end

    def provide_shoulda_matchers_config
      copy_file(
          "shoulda_matchers_config_rspec.rb",
          "spec/support/shoulda_matchers.rb"
      )
    end

    def configure_rspec
      remove_file "spec/rails_helper.rb"
      remove_file "spec/spec_helper.rb"
      copy_file "rails_helper.rb", "spec/rails_helper.rb"
      copy_file "spec_helper.rb", "spec/spec_helper.rb"
    end

    def create_database
      bundle_command 'exec rake db:create db:migrate'
    end

    def create_github_repo(repo_name)
      run "hub create #{repo_name}"
    end

    def setup_spring
      bundle_command "exec spring binstub --all"
    end
  end

  def setup_default_rake_task
    append_file 'Rakefile' do
      <<-EOS
task(:default).clear
task default: [:spec]
if defined? RSpec
  task(:spec).clear
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
  end
end
      EOS
    end
  end
end
