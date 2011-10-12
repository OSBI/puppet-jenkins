class jenkins {

include tomcat
include apache

tomcat::instance {"jenkins":
  ensure      => present,
  ajp_port    => "8000",
  http_port   => "",
}

apache::proxypass {"jenkins":
  ensure   => present,
  location => "/jenkins",
  vhost    => "ci.analytical-labs.com",
  url      => "ajp://localhost:8000",
}

}
