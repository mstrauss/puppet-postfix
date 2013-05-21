# /etc/puppet/modules/postfix/manifests/classes/client.pp

# this is an configurable class for postfix "clients",
# which listen locally only and probably use a smarthost
#
# usage:
#   class { postfix::client: smarthost => "mailhost.internal.net" }
#

class postfix::client(
  $smarthost,
  $mailname = undef,
  $nagios_notification_period = undef
) {

  class { 'postfix': }
  class { 'postfix::nagios': nagios_notification_period => $nagios_notification_period }
  class { 'postfix::relayhost': relayhost => $smarthost }
  class { 'postfix::listen': interfaces => "localhost" }

  # double bounce mails go to postmaster, please
  postfix::maincf { 'notify_classes': ensure => '2bounce, resource, software'; }

  # set mailname
  if $mailname != undef {
    class { postfix::mailname: mailname => $mailname }
  }
}
