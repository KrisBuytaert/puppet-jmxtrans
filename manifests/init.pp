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
    enable    => true ; }
}
class jmxtrans::example {

  file { '/var/lib/jmxtrans/localhost.json':
    group   => '0',
    mode    => '0644',
    owner   => '0',
    source  => 'puppet:///modules/jmxtrans/localhost.json';
  }

}


# Currently mostly using it to send stuff to graphite
# Need to create a ganglia template too

define jmxtrans::graphite ( $jmxport, $jmxhost, $objtype, $attributes,
                            $graphiteport, $graphitehost ,$typenames='',
                            $resultAlias='')
{
  file { "/var/lib/jmxtrans/${name}.json":
    mode     => '0644',
    owner    => '0',
    group    => '0',
    content  => template('jmxtrans/json.graphite.erb');
  }
}
