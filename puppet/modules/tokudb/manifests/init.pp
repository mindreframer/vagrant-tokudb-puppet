class tokudb{
  class{"tokudb::params": }
    -> class{"tokudb::users":}
    -> class{"tokudb::download":}
    -> class{"tokudb::packages":}
    -> class{"tokudb::configs":}
    -> class{"tokudb::initialize":}
    -> class{"tokudb::service":}
}

class tokudb::users{
  user { 'mysql':
    ensure => 'present',
    uid    => $tokudb::params::user_id,
  }
  -> group { "mysql":
    ensure  => "present",
    gid     => $tokudb::params::user_id,
  }
}

class tokudb::download{
  $filepath = $tokudb::params::download_file
  $fullpath = $tokudb::params::fullpath

  file{"/vagrant":
    ensure => directory
  }
  -> exec{"download tokudb":
    command => "curl $tokudb::params::download_url > /vagrant/$filepath",
    unless  =>  "test -e /vagrant/$filepath"
  }
  -> exec{"decompress tokudb":
    command => "echo 1 && cd /usr/local && tar xvfz /vagrant/$filepath",
    unless  => "test -e /usr/local/mysql"
  }
  -> file{"/usr/local/mysql":
    ensure  => link,
    target  => "/usr/local/$fullpath",
  }
  -> exec{"adjust filerights tokudb":
    command => "chown -R mysql:mysql /usr/local/mysql/"
  }
}

class tokudb::packages{
  package{$tokudb::params::packagenames: ensure => installed}
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
  -> file{"/var/lib/mysql":
    ensure => directory,
    owner => 'mysql', group => 'mysql'
  }
}

class tokudb::initialize{
  exec{"init mysql":
    command => "echo 1 && cd /usr/local/mysql && scripts/mysql_install_db --user=mysql && touch /usr/local/mysql/.installed",
    unless  => "test -e /usr/local/mysql/.installed"
  }
}

class tokudb::service{
  service{"mysql":
    ensure    => running,
    subscribe => Class["tokudb::configs"]
  }
}