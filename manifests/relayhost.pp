class postfix::relayhost( $relayhost ) {

  postfix::maincf { 'relayhost':
    ensure => $relayhost,
  }
  
}
