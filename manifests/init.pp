# Class: puppet-jenkins
#
# This module manages puppet-jenkins
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class jenkins {
	include tomcat::source 
	include apache 
	include java 
	$tomcat_version = "6.0.18"
	include git::client 
	include subversion package {
		"unzip" :
			ensure => present,
	}
	package {
		"devscripts" :
			ensure => present,
	}
	package {
		"dh-make" :
			ensure => present,
	}
	apache::vhost {
		"ci.analytical-labs.com" :
			ensure => present,
	}
	apache::vhost {
		"ciarchive.analytical-labs.com" :
			ensure => present,
	}
	tomcat::instance {
		"jenkins" :
			ensure => present,
			ajp_port => "8009",
	}
	apache::proxypass {
		"jenkins" :
			ensure => present,
			location => "/",
			vhost => "ci.analytical-labs.com",
			url => "ajp://localhost:8009/",
	}
	file {
		"/srv/builds" :
			ensure => directory,
			mode => 760,
			owner => www-data,
			group => www-data
	}
	file {
		"/var/www/ciarchive.analytical-labs.com/htdocs/builds" :
			ensure => "/srv/builds"
	}
}
