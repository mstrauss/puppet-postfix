class postfix::tls::client(
  $mandatory_outbound = false,
  $fingerprint        = false,
  $ensure = present
) {

  # validation
  if $mandatory_outbound == 'fingerprint' and $fingerprint == false {
    fail( "postfix::tls::client needs a fingerprint when outbound tls is mandatory with fingerprinting")
  }

  postfix::maincf {
    smtp_tls_CApath:
      ensure => $ensure ? {
        # present => '/etc/ssl/certs',
        default => absent,
      },
      ;
    smtp_tls_CAfile:
      ensure => $ensure ? {
        present => '/etc/ssl/certs/ca-certificates.crt',
        default => absent,
      },
      ;
    smtp_tls_loglevel: 
      ensure => $ensure ? {
        present => '1',
        default => absent,
      },
      ;
    smtp_tls_security_level:
      ensure => $ensure ? {
        present => $mandatory_outbound ? {
          true        => 'encrypt',
          fingerprint => 'fingerprint',
          default     => 'may',
        },
        default => absent,
      }
      ;
    smtp_tls_fingerprint_digest:
      ensure => $ensure ? {
        present => $mandatory_outbound ? {
          fingerprint => 'sha1',
          default     => absent,
        },
        default => absent,
      },
      ;
    smtp_tls_fingerprint_cert_match:
      ensure => $ensure ? {
        present => $mandatory_outbound ? {
          fingerprint => $fingerprint,
          default     => absent,
        },
        default => absent,
      },
      ;
  }

}
