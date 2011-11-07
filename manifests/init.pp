#
# init.pp
# 
# Copyright (c) 2011, OSBI Ltd. All rights reserved.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301  USA
#
class jenkins {

  include tomcat::source
  include apache
  include java
  $tomcat_version = "6.0.18"
  include git::client
  include subversion

  package { "unzip":
    ensure => present,
  }

  package { "devscripts":
    ensure => present,
  }
  package { "dh-make":
    ensure => present,
  }
  apache::module {"proxy_ajp":
    ensure  => present,
  }

  apache::vhost {"ci.analytical-labs.com":
    ensure => present,
  }

  apache::vhost {"ciarchive.analytical-labs.com":
    ensure => present,
  }

  tomcat::instance {"jenkins":
    ensure      => present,
    ajp_port    => "8009",
  }

  apache::proxypass {"jenkins":
    ensure   => present,
    location => "/",
    vhost    => "ci.analytical-labs.com",
    url      => "ajp://localhost:8009/",
  }

  file { "/home/tomcat":
    ensure => directory,
    mode => 700,
    owner => tomcat,
  }

  file { "/srv/builds":
    ensure => directory,
    mode => 760,
    owner => www-data,
    group => www-data
  }

  file { "/var/www/ciarchive.analytical-labs.com/htdocs/builds":
    ensure => "/srv/builds"
  }
}
