#
# Cookbook Name:: mms_agent
# Recipe:: backup
#
# Installs and configures the MMS Backup agent.
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


execute "curl -OL https://mms.mongodb.com/download/agent/backup/mongodb-mms-backup-agent_#{node[:backup_agent][:version]}_amd64.deb" do
  cwd Chef::Config[:file_cache_path]
end

execute "dpkg -i mongodb-mms-backup-agent_#{node[:backup_agent][:version]}_amd64.deb" do
  cwd Chef::Config[:file_cache_path]
end

service 'mongodb-mms-backup-agent' do
  provider Chef::Provider::Service::Upstart
  supports restart: true, start: true, stop: true
end

ruby_block 'modify backup-agent.config' do
  block do
    orig_s = ''
    open("/etc/mongodb-mms/backup-agent.config") do |f|
      orig_s = f.read
    end
    s = orig_s
    s = s.gsub(/apiKey=\n/, "apiKey=#{api_key}\n")

    if s != orig_s
      Chef::Log.debug 'Settings changed, overwriting and restarting service'
      open("/etc/mongodb-mms/backup-agent.config", 'w') do |f|
        f.puts s
      end

      notifies :restart, 'service[mongodb-mms-backup-agent]', :delayed
    end
  end
end

service 'mongodb-mms-backup-agent' do
  action [ :enable, :start ]
end
