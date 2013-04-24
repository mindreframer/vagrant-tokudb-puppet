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

  exec{"mkdir -p /vagrant/binaries":
    unless => "test -e /vagrant/binaries"
  }
  -> exec{"download tokudb":
    command => "curl $tokudb::params::download_url > /vagrant/binaries/$filepath",
    unless  =>  "test -e /vagrant/binaries/$filepath"
  }
  -> exec{"decompress tokudb":
    command => "tar xvfz /vagrant/binaries/$filepath",
    cwd     => "/usr/local",
    unless  => "test -e $tokudb::params::base_dir"
  }
  -> file{$tokudb::params::base_dir:
    ensure  => link,
    target  => "/usr/local/$fullpath",
    owner   => 'mysql', group   => 'mysql'
  }
  -> exec{"adjust filerights tokudb":
    command => "chown -R mysql:mysql $tokudb::params::base_dir",
    unless  => "stat $tokudb::params::base_dir|grep Access|grep mysql"
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
  -> file{$tokudb::params::data_dir:
    ensure => directory,
    owner => 'mysql', group => 'mysql'
  }
}

class tokudb::initialize{
  $check_file = "$tokudb::params::base_dir/.installed"
  exec{"init mysql":
    command => "echo 1 && cd $tokudb::params::base_dir && ./scripts/mysql_install_db --user=mysql && touch $check_file",
    unless  => "test -e $check_file"
  }
}

class tokudb::service{
  service{"mysql":
    ensure    => running,
    subscribe => Class["tokudb::configs"]
  }
}