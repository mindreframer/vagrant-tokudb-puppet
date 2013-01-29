## http://www.onaxer.com/2011/03/08/install-mysql-5-5-on-ubuntu/
class tokudb{
  class{"tokudb::params": }
    -> class{"tokudb::users":}
    -> class{"tokudb::download":}
    -> class{"tokudb::packages":}
    -> class{"tokudb::configs":}
    -> class{"tokudb::initialize":}
    -> class{"tokudb::service":}
}

class tokudb::download{
  $filepath = $tokudb::params::download_file
  $fullpath = $tokudb::params::fullpath
  exec{"decompress mysql":
    command => "echo 1 && cd /usr/local && tar xvfz /vagrant/$filepath",
    unless  => "test -e /usr/local/mysql"
  }

  file{"/usr/local/mysql":
    ensure  => link,
    target  => "/usr/local/$fullpath",
    require => Exec['decompress mysql']
  }

  exec{"chown -R mysql:mysql /usr/local/mysql/":
    require => File['/usr/local/mysql']
  }
}

class tokudb::packages{
  package{"libaio1": ensure => installed}
  package{"mysql-client-core-5.5": ensure => installed}
}

class tokudb::configs{
  file{"/etc/init.d/mysql":
    content => template("tokudb/mysql.server.erb"),
    mode    => 0755,
  }

  file{"/etc/mysql":
    ensure => directory
  }
  -> file{"/etc/mysql/my.cnf":
    content => template("tokudb/my.cnf.erb"),
  }
}

class tokudb::service{

}

class tokudb::initialize{
  exec{"init mysql":
    command => "echo 1 && cd /usr/local/mysql && scripts/mysql_install_db --user=mysql && touch /usr/local/mysql/.installed",
    unless  => "test -e /usr/local/mysql/.installed"
  }
}

class tokudb::users{
  user { 'mysql':
    ensure => 'present'
  }

  group { "mysql":
    ensure  => "present",
    require => User['mysql']
  }
}