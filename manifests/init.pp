class monit($ensure=present, $admin="", $interval=60) {
  $is_present = $ensure == "present"

  package { "monit":
    ensure => $ensure,
  }

  file {
    "/etc/monitrc":
      ensure => $ensure,
      content => template("monit/monitrc.erb"),
      mode => 600,
      require => Package["monit"];

    "/etc/logrotate.d/monit":
      ensure => $ensure,
      source => "puppet:///modules/monit/monit.logrotate",
      require => Package['monit'];
  }

  service { "monit":
    ensure => $is_present,
    enable => $is_present,
    hasrestart => $is_present,
    pattern => $ensure ? {
      'present' => "/usr/bin/monit",
      default => undef,
    },
    subscribe => File["/etc/monitrc"],
    require => [File["/etc/monitrc"],
                File["/etc/logrotate.d/monit"]]
  }
}
