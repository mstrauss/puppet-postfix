define postfix::header_check( $content, $ensure = present ) {

  @file_line { $title:
    path   => '/etc/postfix/header_checks',
    line   => $content,
    tag    => header_check,
    ensure => $ensure,
  }

}
