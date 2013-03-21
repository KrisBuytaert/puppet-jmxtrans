require 'spec_helper'

describe 'jmxtrans::graphite', :type => :define do
  let(:title) { 'graphite' }
  let(:node) { 'blah.acme.com' }
  let(:facts) { { :ipaddress => '10.42.42.42', :domain => 'acme.com' } }

  context "should generate valid config file" do
    let :params do 
    {
      :name                    => 'test',
      :jmxHost                 => 'blah.acme.com',
      :jmxPort                 => '9001',
      :objectType              => 'java.lang:type=Memory',
      :attributes              => '"HeapMemoryUsage", "NonHeapMemoryUsage"',
      :resultAlias             => 'alias',
      :graphiteHost            => 'localhost',
      :graphitePort            => '2004',
      :graphiteTypeNames       => 'names',
      :numQueryThreads         => 100,
      :cronExpression          => '*/15 * * * * * *',
    }
    end

    config_file = "/var/lib/jmxtrans/test.json"
    it { should contain_file(config_file) }
    it 'should have all params that were passed in' do
      content = catalogue.resource('file', config_file).send(:parameters)[:content]
      content.should =~ %r["host": "blah.acme.com"]
      content.should =~ %r["port": "9001"]
      content.should =~ %r["obj": "java.lang:type=Memory"]
      content.should =~ %r["attr": \[ "HeapMemoryUsage", "NonHeapMemoryUsage" \]]
      content.should =~ %r["resultAlias": "alias"]
      content.should =~ %r["host": "localhost"]
      content.should =~ %r["port": 2004]
      content.should =~ %r["typeNames": \[ "names" \]]
      content.should =~ %r["numQueryThreads": 100]
      content.should match '"cronExpression": "\*/15 \* \* \* \* \* \*"'
    end
  end

  context "should generate valid config file with defaults" do
    let :params do 
    {
      :name                    => 'test',
      :jmxHost                 => 'blah.acme.com',
      :jmxPort                 => '9001',
      :objectType              => 'java.lang:type=Memory',
      :attributes              => '"HeapMemoryUsage", "NonHeapMemoryUsage"',
    }
    end

    config_file = "/var/lib/jmxtrans/test.json"
    it { should contain_file(config_file) }
    it 'should have all params that were passed in' do
      content = catalogue.resource('file', config_file).send(:parameters)[:content]
      content.should =~ %r["host": "blah.acme.com"]
      content.should =~ %r["port": "9001"]
      content.should =~ %r["obj": "java.lang:type=Memory"]
      content.should =~ %r["attr": \[ "HeapMemoryUsage", "NonHeapMemoryUsage" \]]
      content.should =~ %r["host": "127.0.0.1"]
      content.should =~ %r["port": 2003]
      content.should =~ %r["numQueryThreads": 1]
    end
  end
end
