class tokudb_mariadb::params{
  $fullpath      = "mariadb-5.5.28a-tokudb-6.6.4-52174-linux-x86_64"
  $download_file = "$fullpath.tar.gz"
  $packagenames  = ["libaio1", "mysql-client-core-5.5"] # ubuntu 12.04
  # a tmp location
  $download_url  = "http://master.dl.sourceforge.net/project/tokudbdownload/mariadb-5.5.28a-tokudb-6.6.4-52174-linux-x86_64.tar.gz"
  # also group_id, for consistency
  $user_id       = 927
  $base_dir      = '/usr/local/mysql'
  $data_dir      = '/var/lib/mysql'
}

