define postfix::header_check( $content, $ensure = present ) {
  
  file { "/var/lib/puppet/modules/postfix/header_checks.d/${title}":
    ensure  => $ensure,
    content => "${content}\n",
    notify  => Exec["concat_/etc/postfix/header_checks"],
  }
  
}
