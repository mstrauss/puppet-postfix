define postfix::maincf( $ensure ) {

  editfile::config { "main.cf ${name}":
    require => Package[postfix],
    path    => '/etc/postfix/main.cf',
    entry   => $name,
    sep     => ' = ',
    ensure  => $ensure,
    notify  => Service[postfix],
  }

}
