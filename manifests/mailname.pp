# Class postfix::mailname
#
# Description
#
# == Parameters
#
#   [*mailname*]
#     mailname to configure
#   [*configure_mydestinations*]
#     Shall we manage mydestination?
#
# == Examples
#
#
# == Requires
#
class postfix::mailname( $mailname, $configure_mydestinations = true ) {

  postfix::maincf {
    myhostname:
      ensure => $mailname;
    myorigin:
      ensure => absent;     # defaults to $myhostname, which is good
  }

  if configure_mydestinations == true {
    postfix::maincf {
      mydestination:
        # we append $::fqdn to the default destinations
        ensure => "\$myhostname, localhost.\$mydomain, localhost, ${::fqdn}";
    }
  }

}
