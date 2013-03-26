class postfix::server::header_checks( $ensure = present ) {
  
  file { '/etc/postfix/header_checks': ensure => $ensure }
  
  if $ensure =~ /present|true/ {
    File_line <| tag == header_check |> {
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
