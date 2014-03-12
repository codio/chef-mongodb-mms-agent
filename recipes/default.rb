#
# Cookbook Name:: mms_agent
# Recipe:: default
#

# Load the MMS agent keys from the data bag `keys.mms_agent`.
begin
  data_bag = Chef::EncryptedDataBagItem.load('keys', 'mms_agent')
  api_key = data_bag['api_key']
rescue
  log "Unable to find encrypted data bag: 'keys.mms_agent'" do
    level :warn
  end
end


# munin-node for hardware info
package 'munin-node'

execute "curl -OL https://mms.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent_#{node[:mms_agent][:version]}_amd64.deb" do
  cwd Chef::Config[:file_cache_path]
end

dpkg_package "mongodb-mms-monitoring-agent" do
  source "#{Chef::Config[:file_cache_path]}/mongodb-mms-monitoring-agent_#{node[:mms_agent][:version]}_amd64.deb"
end

service 'mongodb-mms-monitoring-agent' do
  provider Chef::Provider::Service::Upstart
  supports restart: true, start: true, stop: true
end

ruby_block 'modify monitoring-agent.config' do
  block do
    orig_s = ''
    open("/etc/mongodb-mms/monitoring-agent.config") do |f|
      orig_s = f.read
    end
    s = orig_s
    s = s.gsub(/mmsApiKey=\n/, "mmsApiKey=#{api_key}\n")

    if s != orig_s
      Chef::Log.debug 'Settings changed, overwriting and restarting service'
      open("/etc/mongodb-mms/monitoring-agent.config", 'w') do |f|
        f.puts s
      end

      notifies :restart, 'service[mongodb-mms-monitoring-agent]', :delayed
    end
  end
end

service 'mongodb-mms-monitoring-agent' do
  action [ :enable, :start ]
end
