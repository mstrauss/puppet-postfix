# Define: postfix::pg_lookup
#   see http://www.postfix.org/pgsql_table.5.html
# Parameters:
#   $title: the type of lookup, e.g. alias_maps
#   $hosts: database servers
#
define postfix::pg_lookup( $hosts, $user, $password, $dbname, $query,
  $postfix_user = 'postfix',
  $result_format = '%s', $domain = undef, $ensure = present )
{ 
  Package[postfix] -> Pg_lookup[$title]
  
  if $ensure =~ /present|true/ {
    $postfix_pgsql = 'postfix-pgsql'
    if !defined(Package[$postfix_pgsql]) {
      package{ $postfix_pgsql: ensure => installed }
    }
  }
  
  file{ "/etc/postfix/pgsql_${title}.cf":
    content => template( 'postfix/pg_lookup.cf.erb' ),
    owner   => $postfix_user,
    mode    => 640,
    notify  => Service[postfix],
    ensure  => $ensure,
  }
  
  maincf { $title:
    ensure => $ensure ? {
      /present|true/ => "proxy:pgsql:/etc/postfix/pgsql_${title}.cf",
      /absent|false/ => $ensure,
    },
  }
  
}
