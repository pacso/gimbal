require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Gimbal
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database,
                 type: :string,
                 aliases: '-d',
                 default: 'mysql',
                 desc: "Configure for selected database
(options: #{DATABASES.join("/")})"

    class_option :github,
                 type: :string,
                 aliases: '-G',
                 default: nil,
                 desc: 'Create Github repository and add remote origin pointed to repo'

    class_option :skip_test_unit,
                 type: :boolean,
                 aliases: '-T',
                 default: true,
                 desc: 'Skip Test::Unit files'

    class_option :skip_turbolinks,
                 type: :boolean,
                 default: true,
                 desc: 'Skip turbolinks gem'

    class_option :skip_bundle,
                 type: :boolean,
                 aliases: '-B',
                 default: true,
                 desc: "Don't run bundle install"

    class_option :skip_devise,
                 type: :boolean,
                 default: false,
                 desc: 'Skip devise gem and setup'

    class_option :version,
                 type: :boolean,
                 aliases: '-v',
                 group: :gimbal,
                 desc: 'Show Gimbal version number and quit'

    class_option :help,
                 type: :boolean,
                 aliases: '-h',
                 group: :gimbal,
                 desc: 'Show this help message and quit'

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
      invoke :create_gimbal_views
      invoke :configure_app
      invoke :setup_git
      invoke :setup_database
      invoke :setup_devise
      invoke :create_github_repo
      invoke :setup_analytics
      invoke :setup_bundler_audit
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

      # TODO: Add any custom DB setup here

      build :create_database
    end

    def setup_devise
      if options[:skip_devise]
        say 'Skipping Devise Installation'
      else
        say 'Setting up Devise'

        build :install_devise
        build :generate_devise_model
        build :configure_devise
      end
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_on_delivery_errors
      build :set_dev_mail_delivery_method
      build :add_bullet_gem_configuration
      build :raise_on_unpermitted_parameters
      build :configure_generators
      build :configure_i18n_for_missing_translations
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
      build :configure_i18n_for_test_environment
      build :configure_i18n_tasks
      build :configure_action_mailer_in_specs
    end

    def setup_production_environment
      say 'Setting up the production environment'

    end

    def create_gimbal_views
      say 'Creating gimbal views'
      build :create_partials_directory
      build :create_shared_flashes
      build :create_shared_javascripts
      build :create_application_layout
    end

    def setup_analytics
      say 'Configure Analytics'
      build :create_analytics_partial
    end

    def configure_app
      say 'Configuring app'
      build :configure_time_formats
      build :setup_default_rake_task
      build :configure_puma
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

    def setup_bundler_audit
      say "Setting up bundler-audit"
      build :setup_bundler_audit
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

    def self.banner
      "gimbal #{self.arguments.map(&:usage).join(' ')} [options]"
    end

    def get_builder_class
      Gimbal::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
