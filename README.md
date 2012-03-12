Puppet Monit Module
===================

Module for configuring Monit and and setting up monitoring
of running processes.

Supports CentOS

Installation
------------

Clone this repo to a monit directory under your Puppet
modules directory:

    git clone git://github.com/eklein/puppet-module-monit.git monit

If you don't have a Puppet Master you can create a manifest file
based on the notes below and run Puppet in stand-alone mode
providing the module directory you cloned this repo to:

    puppet apply --modulepath=modules test_monit.pp


Usage
-----

To install and configure Monit, include the module:

    include monit

You can override defaults in the Monit config by including
the module with this special syntax:

    class { monit: admin => "eivind@uggedal.com",
                   mailserver => "hostname",
                   interval => 30 }

Setting up monitoring of processes is done with the `monit::site` resource.

This requires the use of a pidfile OR a string matching the running command!

Note that the name needs to be the same as an init script in `/etc/init.d`:

    monit::monitor { "sshd":
      pidfile => "/var/run/sshd.pid"
    }

OR

    monit::monitor { "sshd":
      matching => "/usr/sbin/sshd"
    }

You can specify a IP port to check if you're running a network process:

    monit::monitor { "nginx":
      pidfile => "/var/run/nginx.pid",
      ip_port => 22,
    }

Additionally, you can specify a Unix socket to check:

    monit::monitor { "gunicorn-blog":
      pidfile => "/var/run/gunicorn/blog.pid",
      socket => "/var/run/gunicorn/blog.sock",
    }

You can also provide additional checks:

    $reload_blog = "/etc/init.d/gunicorn-blog reload"

    monit::monitor { "gunicorn-blog":
      pidfile => "/var/run/gunicorn/blog.pid",
      socket => "/var/run/gunicorn/blog.sock",
      checks => ["if totalmem > 300 MB for 2 cycles then exec \"$reload_blog\"",
                 "if totalmem > 300 MB for 3 cycles then restart",
                 "if cpu > 50% for 2 cycles then alert"],
    }
