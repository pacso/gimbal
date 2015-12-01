require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Gimbal
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "mysql",
                 desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :github, type: :string, aliases: "-G", default: nil,
                 desc: "Create Github repository and add remote origin pointed to repo"

    class_option :skip_test_unit, type: :boolean, aliases: "-T", default: true,
                 desc: "Skip Test::Unit files"

    class_option :skip_turbolinks, type: :boolean, default: true,
                 desc: "Skip turbolinks gem"

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: true,
                 desc: "Don't run bundle install"

    def finish_template
      say 'Finishing template'
      invoke :gimbal_customisation
      super
    end

    def gimbal_customisation
      say 'Gimbal Customisation'
      invoke :customise_gemfile
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_production_environment
      invoke :configure_app
      invoke :setup_git
      invoke :setup_database
      invoke :create_github_repo
      invoke :setup_spring
    end

    def customise_gemfile
      say 'Customising gemfile'
      build :replace_gemfile
      build :set_ruby_to_version_being_used

      bundle_command 'install'
    end

    def setup_database
      say 'Setting up database'

      # if 'mysql' == options[:database]
      #   build :use_mysql_config_template
      # end

      build :create_database
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_on_delivery_errors
      build :set_dev_mail_delivery_method
      build :add_bullet_gem_configuration
      build :raise_on_unpermitted_parameters
    end

    def setup_test_environment
      say 'Setting up the test environment'
      build :raise_on_missing_assets_in_test
      build :set_up_factory_girl_for_rspec
      build :generate_rspec
      build :configure_rspec
      build :enable_database_cleaner
      build :provide_shoulda_matchers_config
      build :configure_spec_support_features
      build :configure_action_mailer_in_specs
    end

    def setup_production_environment
      say 'Setting up the production environment'

    end

    def configure_app
      say 'Configuring app'
      build :setup_default_rake_task
    end

    def setup_git
      if !options[:skip_git]
        say 'Initializing git'
        invoke :setup_gitignore
        invoke :init_git
      end
    end

    def setup_gitignore
      build :gitignore_files
    end

    def setup_spring
      say "Springifying binstubs"
      build :setup_spring
    end

    def init_git
      build :init_git
    end

    def create_github_repo
      if !options[:skip_git] && options[:github]
        say 'Creating Github repo'
        build :create_github_repo, options[:github]
      end
    end

    protected

    def get_builder_class
      Gimbal::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
