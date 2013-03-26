class postfix::server::header_checks( $ensure = present ) {
  
  if $ensure == present {
    modules_dir{ 'postfix/header_checks.d': }
    file { "/var/lib/puppet/modules/postfix/header_checks.d/000-header":
      content => "# managed by puppet\n",
      notify => Exec["concat_/etc/postfix/header_checks"],
    }
    concatenated_file { "/etc/postfix/header_checks":
      dir    => '/var/lib/puppet/modules/postfix/header_checks.d',
      notify => Service[postfix],
    }
  }

  postfix::maincf {
    'header_checks':
      ensure => $ensure ? {
        present => 'regexp:/etc/postfix/header_checks',
        default => absent,
      },
  }

}
