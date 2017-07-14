require "spec_helper"
require "serverspec"

package = "sensu-plugins-bundle"
service = "sensu-plugins-bundle"
config  = "/etc/sensu-plugins-bundle/sensu-plugins-bundle.conf"
user    = "sensu-plugins-bundle"
group   = "sensu-plugins-bundle"
ports   = [PORTS]
log_dir = "/var/log/sensu-plugins-bundle"
db_dir  = "/var/lib/sensu-plugins-bundle"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/sensu-plugins-bundle.conf"
  db_dir = "/var/db/sensu-plugins-bundle"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("sensu-plugins-bundle") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/sensu-plugins-bundle") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
