require 'spec_helper'

describe 'backup recipe' do

  describe user 'mmsagent' do
    it { should exist }
  end

  describe group 'mmsagent' do
    it { should exist }
  end

  describe file '/usr/local/share/mms-agent/backup/local.config' do
    it { should be_a_file }
    it { should be_owned_by 'mmsagent' }
    it { should be_grouped_into 'mmsagent' }
  end

  describe file '/usr/local/share/mms-agent/backup/agent' do
    it { should be_a_file }
    it { should be_executable }
    it { should be_owned_by 'mmsagent' }
    it { should be_grouped_into 'mmsagent' }
  end

  describe file '/var/log/mms-agent' do
    it { should be_directory }
    it { should be_owned_by 'mmsagent' }
    it { should be_grouped_into 'mmsagent' }
  end

  describe service 'mms-backup' do
    it { should be_enabled }
  end

end