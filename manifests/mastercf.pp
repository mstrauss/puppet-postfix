define postfix::mastercf(
  $type    = unix,
  $private = '-',
  $unpriv  = '-',
  $chroot  = '-',
  $wakeup  = '-',
  $maxproc = '-',
  $command,
  $args    = '',
  $ensure  = present )
{
  
  if $args != '' {
    $_args = "  ${args}\n"
  } else {
    $_args = $args
  }
  
  $creates = "${name}\t${type}\t${private}\t${unpriv}\t${chroot}\t${wakeup}\t${maxproc}\t${command}\n${_args}"
  $creates_escaped = inline_template( '<%= Regexp.escape(creates).gsub("/", "\\/") %>' )
  
  editfile { "master.cf ${name}":
    require => Package[postfix],
    path    => '/etc/postfix/master.cf',
    match   => "/^${name}\\s+${type}\\s.*\n(\\s+.*\n)*(?=\\S|\\Z)/",
    ensure => $ensure ? {
      absent  => absent,
      default => "${creates}\\2",
    },
    creates => "/^${creates_escaped}(?=\\S|\\Z)/",
    exact => true,
    notify  => Service[postfix],
  }

}
