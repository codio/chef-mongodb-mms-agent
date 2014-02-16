#
# Cookbook Name:: mms_agent
# Recipe:: default
#

include_recipe 'python'

# Load the MMS agent keys from the data bag `keys.mms_agent`.
begin
  data_bag = Chef::EncryptedDataBagItem.load('keys', 'mms_agent')
  node.default[:mms_agent][:api_key] = data_bag['api_key']
  node.default[:mms_agent][:secret_key] = data_bag['secret_key']
rescue
  log "Unable to find encrypted data bag: 'keys.mms_agent'" do
    level :warn
  end
end


# munin-node for hardware info
package 'munin-node'

# Create the system user and group.
group node[:mms_agent][:user]
user node[:mms_agent][:user] do
  gid node[:mms_agent][:group]
end

# download

execute "wget https://mms.mongodb.com/settings/mmsAgent/#{node[:mms_agent][:api_key]}/mms-monitoring-agent-codio.zip" do
  cwd Chef::Config[:file_cache_path]
end

package 'unzip'
remote_file "#{Chef::Config[:file_cache_path]}/mms-monitoring-agent.zip" do
  source "file://#{Chef::Config[:file_cache_path]}/mms-monitoring-agent-codio.zip"
  notifies :run, "bash[unzip_mms_monitoring_agent]", :immediately
  notifies :restart, "service[mms-agent]"
end

# unzip
bash 'unzip_mms_monitoring_agent' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    unzip -o -d mms-monitoring-agent mms-monitoring-agent.zip
    cp -r mms-monitoring-agent/mms-agent/* /usr/local/share/mms-agent
  EOH
  action :nothing
end

# install pymongo
python_pip 'pymongo' do
  action :install
end

directory '/var/log/mms-agent' do
  owner node[:mms_agent][:user]
  group node[:mms_agent][:group]
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
  notifies :restart, "service[mms-agent]"
end

service "mms-agent" do
  action [:enable, :start]
end