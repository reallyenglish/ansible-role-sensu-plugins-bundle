require "spec_helper"
require "serverspec"

plugins_dir = "/etc/sensu/plugins"
bundled_plugins_dir = "/etc/sensu/bundled_plugins"
git_package = "git"
bundler_package = "bundler"
user = "sensu"
group = "sensu"

case os[:family]
when "freebsd"
  plugins_dir = "/usr/local/etc/sensu/plugins"
  bundled_plugins_dir = "/usr/local/etc/sensu/bundled_plugins"
  bundler_package = "rubygem-bundler"
end

[git_package, bundler_package].each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe file("#{plugins_dir}/bundled_check") do
  it { should be_exist }
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(bundled_plugins_dir) do
  it { should be_exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file("#{bundled_plugins_dir}/sensu-plugins-load-checks") do
  it { should be_exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file("#{bundled_plugins_dir}/sensu-plugins-load-checks/vendor/bundle") do
  it { should be_exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file("#{bundled_plugins_dir}/sensu-plugins-load-checks/Gemfile") do
  it { should be_exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe command("( cd #{bundled_plugins_dir}/sensu-plugins-load-checks && bundle exec gem list )") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/sensu-plugins-load-checks/) }
end

describe command("#{plugins_dir}/bundled_check sensu-plugins-load-checks check-load.rb -c 1000,1000,1000 -w 1000,1000,1000") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/\sOK:/) }
end
