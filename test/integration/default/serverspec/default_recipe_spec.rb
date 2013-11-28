require 'spec_helper'

describe 'default recipe' do

  describe user 'mmsagent' do
    it { should exist }
  end

  describe group 'mmsagent' do
    it { should exist }
  end

  %w( munin-node unzip ).each do |pkg|
    describe package pkg do
      it { should be_installed }
    end
  end

  describe file('/usr/local/share/mms-agent') do
    it { should be_directory }
  end

  describe file '/usr/local/share/mms-agent/settings.py' do
    its(:content) { should_not match /@API_KEY@/ }
    its(:content) { should_not match /@SECRET_KEY@/ }
  end

  describe file '/var/log/mms-agent' do
    it { should be_directory }
    it { should be_owned_by 'mmsagent' }
    it { should be_grouped_into 'mmsagent' }
  end

  describe service 'mms-agent' do
    it { should be_running.under('upstart') }
  end

end