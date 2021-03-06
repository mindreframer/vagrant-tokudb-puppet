class tokudb::params{
  #$fullpath      = "mysql-5.5.28-tokudb-6.6.4-52174-linux-x86_64"
  $fullpath      = "mysql-5.5.30-tokudb-7.0.1-linux-x86_64"
  $download_file = "$fullpath.tar.gz"
  $packagenames  = ["libaio1", "mysql-client-core-5.5"] # ubuntu 12.04
  # a tmp location
  $download_url  = "http://master.dl.sourceforge.net/project/tokudbdownload/$download_file"
  # also group_id, for consistency
  $user_id       = 927
  $base_dir      = '/usr/local/mysql'
  $data_dir      = '/var/lib/mysql'
}