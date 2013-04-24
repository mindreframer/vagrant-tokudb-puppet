# http://master.dl.sourceforge.net/project/tokudbdownload/mysql-5.5.28-tokudb-6.6.4-52174-linux-x86_64.tar.gz
# remove osx files
find binaries|grep .DS |xargs rm
# upload binaries folder
rsync -rv binaries/ -e ssh mindreframer@frs.sourceforge.net:/home/frs/project/tokudbdownload/