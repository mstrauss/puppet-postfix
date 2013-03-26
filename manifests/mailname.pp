# $title : mailname to configure
define postfix::mailname() {
  
  postfix::maincf {
    myhostname:
      ensure => $title;
    myorigin:
      ensure => absent;     # defaults to $myhostname, which is good
    mydestination:
      # we append $::fqdn to the default destinations
      ensure => "\$myhostname, localhost.\$mydomain, localhost, ${::fqdn}";
  }

}
