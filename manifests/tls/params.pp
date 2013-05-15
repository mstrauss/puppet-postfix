class postfix::tls::params {

  include ssl::params
  $default_ssl_cert = $ssl::params::ssl_cert_file
  $default_ssl_key  = $ssl::params::ssl_key_file

}
