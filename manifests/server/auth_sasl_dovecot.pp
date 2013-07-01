# http://www.postfix.org/SASL_README.html

class postfix::server::auth_sasl_dovecot() {

  Package[postfix] -> Class[postfix::server::auth_sasl_dovecot]

  postfix::maincf {
    smtpd_sasl_type: ensure => 'dovecot';
    smtpd_sasl_path: ensure => 'private/auth';
  }

}
