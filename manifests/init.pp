# /etc/puppet/modules/postfix/manifests/init.pp

class postfix( $ensure = present ) {
  
  package { "postfix": ensure => $ensure }
  
  if $ensure == present {
    
    service { "postfix": ensure => running, require => Package["postfix"] }
    
    file { '/etc/mailname':
      content => "${::fqdn}\n",
      notify  => Service[postfix],
    }

    file { "/var/lib/postfix":
      require => Package[postfix],
      owner   => postfix,
      group   => postfix,
      mode    => 600,
      notify  => Service[postfix],
      recurse => true,
    }

    exec { "newaliases":
      refreshonly => true,
      command     => '/usr/bin/newaliases',
      notify      => Service[postfix],
    }

  }
  
}
