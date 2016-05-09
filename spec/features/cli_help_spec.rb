require "spec_helper"

RSpec.describe "Command line help output" do
  let(:help_text) { gimbal_help_command }

  it "does not contain the default rails usage statement" do
    expect(help_text).not_to include("rails new APP_PATH [options]")
  end

  it "provides the correct usage statement for gimbal" do
    expect(help_text).to include <<-EOH
Usage:
  gimbal APP_PATH [options]
EOH
  end

  it "does not contain the default rails group" do
    expect(help_text).not_to include("Rails options:")
  end

  it "provides help and version usage within the gimbal group" do
    expect(help_text).to include <<-EOH
Gimbal options:
  -h, [--help], [--no-help]        # Show this help message and quit
  -v, [--version], [--no-version]  # Show Gimbal version number and quit
    EOH
  end

  it "does not show the default extended rails help section" do
    expect(help_text).not_to include("Create suspenders files for app generator.")
  end

  it "contains the usage statement from the gimbal gem" do
    expect(help_text).to include IO.read(usage_file)
  end
end
