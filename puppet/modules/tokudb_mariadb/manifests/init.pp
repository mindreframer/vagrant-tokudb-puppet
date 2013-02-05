

class tokudb_mariadb{
  class{"tokudb::params": }
    -> class{"tokudb_mariadb::users":}
    -> class{"tokudb_mariadb::download":}
    -> class{"tokudb_mariadb::packages":}
    -> class{"tokudb_mariadb::configs":}
    -> class{"tokudb_mariadb::initialize":}
    -> class{"tokudb_mariadb::service":}
}

class tokudb_mariadb::users{
  user { 'mysql':
    ensure => 'present',
    uid    => $tokudb_mariadb::params::user_id,
  }
  -> group { "mysql":
    ensure  => "present",
    gid     => $tokudb_mariadb::params::user_id,
  }
}

class tokudb_mariadb::download{
  $filepath = $tokudb_mariadb::params::download_file
  $fullpath = $tokudb_mariadb::params::fullpath

  exec{"mkdir -p /vagrant":
    unless => "test -e /vagrant"
  }
  -> exec{"download tokudb_mariadb":
    command => "curl $tokudb_mariadb::params::download_url > /vagrant/$filepath",
    unless  =>  "test -e /vagrant/$filepath"
  }
  -> exec{"decompress tokudb_mariadb":
    command => "tar xvfz /vagrant/$filepath",
    cwd     => "/usr/local",
    unless  => "test -e $tokudb_mariadb::params::base_dir"
  }
  -> file{$tokudb_mariadb::params::base_dir:
    ensure  => link,
    target  => "/usr/local/$fullpath",
    owner   => 'mysql', group   => 'mysql'
  }
  -> exec{"adjust filerights tokudb":
    command => "chown -R mysql:mysql $tokudb_mariadb::params::base_dir",
    unless  => "stat $tokudb_mariadb::params::base_dir|grep Access|grep mysql"
  }
}

class tokudb_mariadb::packages{
  package{$tokudb_mariadb::params::packagenames: ensure => installed}
}

class tokudb_mariadb::configs{
  file{"/etc/init.d/mysql":
    content => template("tokudb_mariadb/mysql.server.erb"),
    mode    => 0755,
  }

  file{"/etc/mysql":
    ensure => directory
  }
  -> file{"/etc/mysql/my.cnf":
    content => template("tokudb_mariadb/my.cnf.erb"),
  }
  -> file{$tokudb_mariadb::params::data_dir:
    ensure => directory,
    owner => 'mysql', group => 'mysql'
  }
}

class tokudb_mariadb::initialize{
  $check_file = "$tokudb_mariadb::params::base_dir/.installed"
  exec{"init mysql":
    command => "echo 1 && cd $tokudb_mariadb::params::base_dir && ./scripts/mysql_install_db --user=mysql && touch $check_file",
    unless  => "test -e $check_file"
  }
}

class tokudb_mariadb::service{
  service{"mysql":
    ensure    => running,
    subscribe => Class["tokudb_mariadb::configs"]
  }
}