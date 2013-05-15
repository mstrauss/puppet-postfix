# Set $ssl_port to 'smtps' if you want to enable SSL on this port 465.
class postfix::tls::server(
  $crtpath           = $postfix::tls::params::default_ssl_cert,
  $keypath           = $postfix::tls::params::default_ssl_cert,
  $mandatory_inbound = false,
  $ssl_port          = undef,
) inherits postfix::tls::params {

  postfix::maincf {
    smtpd_tls_cert_file:
      require => File[$crtpath],
      ensure  => $crtpath;
    smtpd_tls_key_file:
      require => File[$keypath],
      ensure => $keypath;
    smtpd_tls_received_header: ensure => 'yes';
    smtpd_tls_security_level:  ensure => $mandatory_inbound ? {
      true    => 'encrypt',
      default => 'may',
    };
    smtpd_tls_CApath: ensure => absent;
    # to verify outbound TLS connections
    smtpd_tls_CAfile: ensure => '/etc/ssl/certs/ca-certificates.crt';
  }

  if $ssl_port != undef {
    editfile::config { "enable smtps on port ${ssl_port}":
      require => Package[postfix],
      path    => '/etc/postfix/master.cf',
      # ensure  => "${ssl_port} inet n - - - - smtpd -o smtpd_tls_wrappermode=yes -o smtpd_sasl_auth_enable=yes -o smtpd_client_restrictions=permit_sasl_authenticated,reject",
      ensure  => "${ssl_port} inet n - - - - smtpd -o smtpd_tls_wrappermode=yes",
      notify  => Service[postfix],
    }
  }

}
