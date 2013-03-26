# /etc/puppet/modules/postfix/manifests/classes/server.pp

class postfix::server(
  $mailname  = undef,
  $smarthost = absent,
  $header_checks = false,
  $mynetworks = undef,
  $submission = false,
  $nagios_notification_period = undef,
  $nagios_warn = 15,
  $nagios_crit = 50,
  $ensure = present
) {

  modules_dir { 'postfix': }

  class { 'postfix': }
  class { 'postfix::nagios':
    warn => $nagios_warn, crit => $nagios_crit,
    nagios_notification_period => $nagios_notification_period,
  }
  class { 'postfix::relayhost': relayhost => $smarthost }
  class { 'postfix::server::header_checks': ensure => $header_checks }

  if $mailname != undef {
    postfix::mailname { $mailname: }
  }
  
  if $submission =~ /^(true|present)$/ {
    editfile::config { 'enable submission':
      require => Package[postfix],
      path    => '/etc/postfix/master.cf',
      ensure  => 'submission inet n - - - - smtpd',
      notify  => Service[postfix],
    }
  } elsif $submission =~ /^(false|absent)$/ {
    editfile { 'disable submission':
      require => Package[postfix],
      path    => '/etc/postfix/master.cf',
      match   => '/^submission/',
      ensure  => absent,
      notify  => Service[postfix],
    }
  }


  if $mynetworks != undef {
    
    $_networks = join( $mynetworks, ' ' )

    postfix::maincf { mynetworks:
      # allowed is localhost and our list
      ensure => "127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 ${_networks}",
    }
  }

  # this is a server => listen on all interfaces
  class { 'postfix::listen': interfaces => "all" }
  
  # double bounce mails go to postmaster, please
  postfix::maincf { 'notify_classes': ensure => '2bounce, resource, software'; }

}
