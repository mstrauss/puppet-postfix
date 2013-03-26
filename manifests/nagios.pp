# Class: postfix::nagios
#
#
class postfix::nagios(
  $warn = 1,
  $crit = 5,
  $nagios_notification_period = undef ) {

  @@nagios_service { "check_mailq_${::hostname}":
    check_command       => "ssh_mailq!${warn}!${crit}",
    host_name           => "$::fqdn",
    use                 => 'generic-service',
    service_description => 'Mail Queue',
    notify              => Service[nagios],
    notification_period => $nagios_notification_period,
    servicegroups       => 'Mail Queues',
  }

}
