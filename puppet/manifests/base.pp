# this is the entry point for puppet client
# setup some basic stuff here

# puppet group
group { "puppet":
  ensure => "present",
}

# the default path for puppet to look for executables
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# the default file attributes
File { owner => 0, group => 0, mode => 0644 }

# we define run-stages, so we can prepare the system
# to have basic requirements installed
# http://docs.puppetlabs.com/puppet/2.7/reference/lang_run_stages.html

# first stage should do general OS updating/upgrading
stage { 'first': }

# last stage should cleanup/ do something unusual
stage { 'last': }

# declare dependancies
Stage['first'] -> Stage['main'] -> Stage['last']

# just some packages
package{"tmux": ensure => installed}
package{"curl": ensure => installed}

# a helper script to run puppet
file{"/usr/local/bin/runpuppet":
  content => "sudo puppet apply -vv  --modulepath=/tmp/vagrant-puppet/modules-0/ /tmp/vagrant-puppet/manifests/base.pp\n",
  mode    => 0755
}

# brings the system up-to-date after importing it with Vagrant
# runs only once after booting (checks /tmp/apt-get-update existence)
class update_aptget{
  exec{"apt-get update && touch /tmp/apt-get-updated":
    unless => "test -e /tmp/apt-get-updated"
  }
}

# run apt-get update before anything else runs
class {'update_aptget':
  stage => first,
}

class{"tokudb": }
