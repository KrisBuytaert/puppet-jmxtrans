# Class: jmxtrans
#
# This module manages jmxtrans
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class jmxtrans {

  package {'jmxtrans':
    ensure => present;
  }


  # Current JMX trans service script doesn't return exict codes correctly,
  # patch subbmitted  upstream and accepted.
  # Next JMX trans will  have good rc script

  service {'jmxtrans':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['jmxtrans'],
  }
}

class jmxtrans::example {

  file { '/var/lib/jmxtrans/localhost.json':
    group   => '0',
    mode    => '0644',
    owner   => '0',
    source  => 'puppet:///modules/jmxtrans/localhost.json',
    require => Package['jmxtrans'],
  }

}

# Currently mostly using it to send stuff to graphite
# Need to create a ganglia template too

define jmxtrans::graphite ( 
  $jmxHost, $jmxPort, 
  $objectType, $attributes, $resultAlias='',
  $outputWriterClass='com.googlecode.jmxtrans.model.output.GraphiteWriter',
  $graphiteHost='127.0.0.1', $graphitePort='2003', $graphiteTypeNames='',
  $queryIntervalInSeconds=30, $numQueryThreads=1,
  $exportIntervalInSeconds=5, $numExportThreads=1,
  $exportBatchSize=50)
{
  file { "/var/lib/jmxtrans/${name}.json":
    mode     => '0644',
    owner    => '0',
    group    => '0',
    content  => template('jmxtrans/json.graphite.erb'),
    require => Package['jmxtrans'],
  }
}
