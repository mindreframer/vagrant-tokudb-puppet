# TokuDB v. 7 is Open Source!



# Requirements:

      - Vagrant (http://www.vagrantup.com/)

### Usage:

    $ git clone git://github.com/mindreframer/vagrant-tokudb-puppet.git
    $ cd vagrant-tokudb-puppet

    # start vagrant
    $ vagrant up

    # ssh into your VM
    $ vagrant ssh


#### runpuppet (run  puppet), run under `vagrant`-user:
    $ runpuppet


#### download Tokudb (you'll need to register)

    http://www.tokutek.com/resources/support/gadownloads/

  The Puppet module  works with `mariadb-5.5.30-tokudb-7.0.1-linux-x86_64` and `mysql-5.5.30-tokudb-7.0.1-linux-x86_64`.
