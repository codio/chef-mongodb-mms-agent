#
# Cookbook Name:: mms_agent
# Recipe:: default
#

include_recipe 'python'


require 'fileutils'

# munin-node for hardware info
package 'munin-node'

group node[:mms_agent][:user]
user node[:mms_agent][:user] do
  gid node[:mms_agent][:group]
end

# download
package 'unzip'
remote_file '/tmp/10gen-mms-agent.zip' do
  source 'https://mms.10gen.com/settings/10gen-mms-agent.zip'
end

# unzip
bash 'unzip 10gen-mms-agent' do
  cwd '/tmp/'
  code <<-EOH
    unzip -o -d /usr/local/share/ ./10gen-mms-agent.zip
  EOH
  not_if { File.exist?('/usr/local/share/mms-agent') }
end

# install pymongo
python_pip 'pymongo' do
  action :install
end

# modify settings.py
ruby_block 'modify settings.py' do
  block do
    orig_s = ''
    open('/usr/local/share/mms-agent/settings.py') { |f|
      orig_s = f.read
    }
    s = orig_s
    s = s.gsub(/mms\.10gen\.com/, 'mms.10gen.com')
    s = s.gsub(/@API_KEY@/, node[:mms_agent][:api_key])
    s = s.gsub(/@SECRET_KEY@/, node[:mms_agent][:secret_key])
    if s != orig_s
      open('/usr/local/share/mms-agent/settings.py','w') { |f|
        f.puts(s)
      }
    end
  end
end

directory '/var/log/mms-agent' do
  owner node[:mms_agent][:user]
  group node[:mms_agent][:grioup]
end

service "mms-agent" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
end

template "mms-agent.upstart.conf" do
  path "/etc/init/mms-agent.conf"
  source "mms-agent.upstart.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "mms-agent")
end

service "mms-agent" do
  action [:enable, :start]
end