require 'spec_helper'

RSpec.describe 'Create a new project' do
  before(:all) do
    drop_dummy_database
    remove_project_directory
  end

  context 'skipping devise' do
    before(:all) do
      run_gimbal('--skip-devise')
    end

    it 'leaves the devise gem disabled' do
      gemfile = IO.read("#{project_path}/Gemfile")
      expect(gemfile).to match(/^\# gem "devise"$/)
    end
  end

  context 'skipping administrate' do
    before(:all) do
      run_gimbal('--skip-administrate')
    end

    it 'leaves the administrate gem disabled' do
      gemfile = IO.read("#{project_path}/Gemfile")
      expect(gemfile).to match(/^\# gem "administrate"$/)
    end
  end

  context 'with default config' do
    before(:all) do
      run_gimbal
    end

    it 'ensures project specs pass' do
      Dir.chdir(project_path) do
        Bundler.with_clean_env do
          expect(`rake`).to match(/0 failures/)
        end
      end
    end

    it 'configs missing assets to raise in test' do
      test_config = IO.read("#{project_path}/config/environments/test.rb")

      expect(test_config).to match(
        /^ +config.assets.raise_runtime_errors = true$/
      )
    end

    it 'configs raise_on_delivery errors in development' do
      dev_config = IO.read("#{project_path}/config/environments/development.rb")

      expect(dev_config).to match(
        /^ +config.action_mailer.raise_delivery_errors = true$/,
      )
    end

    it 'configs development to send mail using letter_opener' do
      dev_config = IO.read("#{project_path}/config/environments/development.rb")

      expect(dev_config).to match(
        /^ +config.action_mailer.delivery_method = :letter_opener/,
      )
    end

    it 'configs development to raise on missing translations' do
      dev_config = IO.read("#{project_path}/config/environments/development.rb")

      expect(dev_config).to match(
        /^ +config.action_view.raise_on_missing_translations = true/
      )
    end

    it 'configs test to raise on missing translations' do
      dev_config = IO.read("#{project_path}/config/environments/test.rb")

      expect(dev_config).to match(
        /^ +config.action_view.raise_on_missing_translations = true/
      )
    end

    it 'configs bullet gem in development' do
      dev_config = IO.read("#{project_path}/config/environments/development.rb")

      expect(dev_config).to match(/^ +Bullet.enable = true$/)
      expect(dev_config).to match(/^ +Bullet.bullet_logger = true$/)
      expect(dev_config).to match(/^ +Bullet.rails_logger = true$/)
    end

    it 'enables the administrate gem' do
      gemfile = IO.read("#{project_path}/Gemfile")
      expect(gemfile).to match(/^gem "administrate"$/)
    end

    it 'enables the devise gem' do
      gemfile = IO.read("#{project_path}/Gemfile")
      expect(gemfile).to match(/^gem "devise"$/)
    end

    it 'raises on unpermitted parameters in all environments' do
      result = IO.read("#{project_path}/config/application.rb")

      expect(result).to match(
        /^ +config.action_controller.action_on_unpermitted_parameters = :raise$/
      )
    end

    it 'configures generators' do
      result = IO.read("#{project_path}/config/application.rb")

      expect(result).to match(/^ +generate.helper false$/)
      expect(result).to match(/^ +generate.javascript_engine false$/)
      expect(result).to match(/^ +generate.request_specs false$/)
      expect(result).to match(/^ +generate.routing_specs false$/)
      expect(result).to match(/^ +generate.stylesheets false$/)
      expect(result).to match(/^ +generate.test_framework :rspec/)
      expect(result).to match(/^ +generate.view_specs false/)
    end

    it 'removes the default erb layout' do
      expect(File).not_to exist(
        "#{project_path}/app/views/layouts/application.html.erb"
      )
    end

    it 'configures language in html element' do
      layout_path = '/app/views/layouts/application.html.haml'
      layout_file = IO.read("#{project_path}#{layout_path}")
      expect(layout_file).to match(/%html\{lang: 'en'\}/)
    end

    it 'evaluates en.yml.erb' do
      locales_en_file = IO.read("#{project_path}/config/locales/en.yml")
      app_name = GimbalTestHelpers::APP_NAME

      expect(locales_en_file).to match(/application: #{app_name.humanize}/)
    end

    it 'adds support file for action mailer' do
      expect(File).to exist("#{project_path}/spec/support/action_mailer.rb")
    end

    it 'adds support file for factory girl' do
      expect(File).to exist("#{project_path}/spec/support/factory_girl.rb")
    end

    it 'adds support file for database cleaner' do
      expect(File).to exist("#{project_path}/spec/support/database_cleaner.rb")
    end

    it 'adds support file for database cleaner' do
      expect(File).to exist("#{project_path}/spec/support/shoulda_matchers.rb")
    end

    it 'adds support file for i18n' do
      expect(File).to exist("#{project_path}/spec/support/i18n.rb")
    end

    it 'adds specs for missing or unused translations' do
      expect(File).to exist("#{project_path}/spec/i18n_spec.rb")
    end

    it 'configs i18n-tasks' do
      expect(File).to exist("#{project_path}/config/i18n-tasks.yml")
    end

    it 'creates .ruby-version from Gimbal .ruby-version' do
      ruby_version_file = IO.read("#{project_path}/.ruby-version")

      expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
    end
  end
end
