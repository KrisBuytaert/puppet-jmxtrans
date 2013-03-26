require 'spec_helper'

describe 'jmxtrans::graphite', :type => :define do
  let(:title) { 'graphite' }
  let(:node) { 'blah.acme.com' }
  let(:facts) { { :ipaddress => '10.42.42.42', :domain => 'acme.com' } }

  # EVERYTHING
  context "should generate valid config file with everything specified" do
    let :params do 
    {
      :name                    => 'test',
      :jmxHost                 => 'blah.acme.com',
      :jmxPort                 => '9001',
      :serverAlias             => 'myserver',
      :objectType              => 'java.lang:type=Memory',
      :attributes              => '"HeapMemoryUsage", "NonHeapMemoryUsage"',
      :resultAlias             => 'alias',
      :graphiteHost            => 'localhost',
      :graphitePort            => '2004',
      :graphiteTypeNames       => '"name1", "name2"',
      :graphiteRootPrefix      => 'com.test',
      :serverAlias             => 'myserver',
      :numQueryThreads         => 100,
      :cronExpression          => '*/15 * * * * * *',
    }
    end

    config_file = "/var/lib/jmxtrans/test.json"
    it { should contain_file(config_file) }
    it 'should have all params that were passed in' do
      content = catalogue.resource('file', config_file).send(:parameters)[:content]
      content.should =~ %r["host": "blah.acme.com",]
      content.should =~ %r["port": "9001",]
      content.should =~ %r["alias": "myserver",]
      content.should =~ %r["obj": "java.lang:type=Memory",]
      content.should =~ %r["attr": \[ "HeapMemoryUsage", "NonHeapMemoryUsage" \],]
      content.should =~ %r["resultAlias": "alias",]
      content.should =~ %r["host": "localhost",]
      content.should =~ %r["port": 2004,]
      content.should =~ %r["typeNames": \[ "name1", "name2" \],]
      content.should =~ %r["rootPrefix": "com.test"]
      content.should =~ %r["numQueryThreads": 100]
      content.should match '"cronExpression": "\*/15 \* \* \* \* \* \*"'
    end
  end

  # DEFAULTS
  context "should generate valid config file with defaults and not optional params" do
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

      # these were optional and not specified, so they shouldn't end up in the output
      content.should_not =~ %r["alias":]
      content.should_not =~ %r["resultAlias":]
      content.should_not =~ %r["typeNames":]
      content.should_not =~ %r["rootPrefix":]
    end
  end

  # TRAILING 1
  context "ensure there's no trailing , if graphiteTypeName is specified and no rootPrefix is specified" do
    let :params do 
    {
      :name                    => 'test',
      :jmxHost                 => 'blah.acme.com',
      :jmxPort                 => '9001',
      :objectType              => 'java.lang:type=Memory',
      :attributes              => '"HeapMemoryUsage", "NonHeapMemoryUsage"',
      :graphiteTypeNames       => '"someType"',
    }
    end

    config_file = "/var/lib/jmxtrans/test.json"
    it { should contain_file(config_file) }
    it 'should have all params that were passed in' do
      content = catalogue.resource('file', config_file).send(:parameters)[:content]
      content.should =~ %r["typeNames": \[ "someType" \]$]
      content.should_not =~ %r["rootPrefix":]
    end
  end

  # TRAILING 2
  context "ensure there's no trailing , if numQueryThreads is specified and no cronExpression is specified" do
    let :params do 
    {
      :name                    => 'test',
      :jmxHost                 => 'blah.acme.com',
      :jmxPort                 => '9001',
      :objectType              => 'java.lang:type=Memory',
      :attributes              => '"HeapMemoryUsage", "NonHeapMemoryUsage"',
      :numQueryThreads         => '2',
    }
    end

    config_file = "/var/lib/jmxtrans/test.json"
    it { should contain_file(config_file) }
    it 'should have all params that were passed in' do
      content = catalogue.resource('file', config_file).send(:parameters)[:content]
      content.should =~ %r["numQueryThreads": 2$]
      content.should_not =~ %r["cronExpression":]
    end
  end

end
