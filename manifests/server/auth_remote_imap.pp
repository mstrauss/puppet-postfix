# http://stoilis.blogspot.com/2005/09/postfix-smtp-authentication-against.html
# http://www.postfix.org/SASL_README.html

class postfix::server::auth_remote_imap( $imapserver, $stunnel, $debug = false ) {

  Package[postfix] -> Class[postfix::server::auth_remote_imap]
  
  # required packages
  package { [ libsasl2-modules, sasl2-bin ]: }

  if $stunnel == 'yes' {
    package { stunnel: }

    # FixMe: Das sollte nicht mit Puppet gestartet werden!
    exec { "stunnel -c -d localhost:imap -r ${imapserver}:993 -D 7 -o /var/log/stunnel4/stunnel.log":
      require => Package[stunnel],
      unless  => 'pgrep stunnel',
    }

    # ERB vars.
    $_imapserver = "127.0.0.1"
  } else {
    $_imapserver = $imapserver
  }

  postfix::maincf {
    smtpd_sasl_auth_enable:
      ensure => 'yes';
    smtpd_client_restrictions:
      ensure => 'permit_mynetworks,permit_sasl_authenticated,reject';
    smtpd_recipient_restrictions:
      ensure => 'permit_sasl_authenticated,reject_unauth_destination';
    relay_domains:
      ensure => absent;
    smtpd_tls_auth_only:
      ensure => 'yes';
  }

  user { "postfix":
    groups => "sasl",
  }

  file { "/etc/postfix/sasl/smtpd.conf":
    content => template("postfix/sasl-smtpd.conf.erb"),
    notify => Service[saslauthd],
  }

  if $debug == true {
    $debug_flag = '-d'
  } else {
    $debug_flag = ''
  }
  file { "/etc/default/saslauthd":
    content => template( "postfix/saslauthd.erb" ),
    notify => Service[saslauthd],
  }

  service { "saslauthd":
    require => Package[sasl2-bin],
    ensure => running,
    hasstatus => false,
  }


}
