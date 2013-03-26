# /etc/puppet/modules/postfix/manifests/definitions/listen.pp

class postfix::listen( $interfaces ) {

  postfix::maincf { 'inet_interfaces': ensure => $interfaces }

}
