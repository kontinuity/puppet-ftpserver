# == Class: ftpserver
#
# Full description of class ftpserver here.
#
# === Parameters
#
# Document parameters here.
#
# Hiera_yaml
# ftpserver::anonymous_enable: 'NO'
# ftpserver::write_enable: 'YES'
# ftpserver::ftpd_banner: 'FTP Server'
# ftpserver::chroot_local_user: 'YES'
# ftpserver::ftpusers:
#   user1:
#     comment: "FTP User 1"
#     home: "/data/ftp/user1"
#     password: "password"
#   user2:
#     comment: "FTP User 2"
#     home: "/data/ftp/user2"
#     password: "password"
#  
#
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { ftpserver:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class ftpserver (
  $backmeup = false,
  $backuphour = 1,
  $backupminute = 1,
  $bucket = 'ftpserver',
  $dest_id = undef,
  $dest_key = undef,
  $cloud = 's3',
  $pubkey_id = undef,
  $full_if_older_than = undef,
  $remove_older_than = undef,
  $anonymous_enable 	= 'NO',
  $write_enable		= 'YES',
  $ftpd_banner 		= 'FTP Server',
  $chroot_local_user 	= 'YES',
  $chroot_list_enable   = 'YES',
  $userlist_enable	= 'NO',
  $chroot_list_file     = '/etc/vsftpd.chroot_list', 
  $pasv_min_port     	= '10000',
  $pasv_max_port     	= '10200',
  $ftpuserrootdirs	= ['/data',
			   '/data/ftp'],
) {

  firewall { "000 accept all icmp requests":
    proto  => "icmp",
    action => "accept",
  }

  firewall { '100 allow ftp and ssh access':
    port   => [20, 21, 22],
    proto  => tcp,
    action => accept,
  }
                                    
  firewall { '200 allow passive ftp port range':
    port   => ["$pasv_min_port-$pasv_max_port"],
    proto  => tcp,
    action => accept,
  }

  resources { 'firewall':
    purge => true
  }

  if $backmeup == true {
    class { 'ftpserver::backmeup':
      backuphour         => $backuphour,
      backupminute       => $backupminute,
      backupdir          => $ftpuserrootdirs[0],
      bucket             => $bucket,
      dest_id            => $dest_id,
      dest_key           => $dest_key,
      cloud              => $cloud,
      pubkey_id          => $pubkey_id,
      full_if_older_than => $full_if_older_than,
      remove_older_than  => $remove_older_than,
    }
  }

  group { 'ftpusers':
    ensure	=> present,
  }

  file { $ftpuserrootdirs:
    ensure	=> 'directory',
  }

  create_resources('ftpserver::users', hiera('ftpserver::users', []))

  file { $chroot_list_file:
    content	=> template('ftpserver/vsftpd.chroot_list.erb'),
  }

  class { 'vsftpd':
    anonymous_enable  => $anonymous_enable,
    write_enable      => $write_enable,
    ftpd_banner       => $ftpd_banner,
    chroot_local_user => $chroot_local_user,
    chroot_list_enable=> $chroot_list_enable,
    chroot_list_file  => $chroot_list_file, 
    userlist_enable   => $userlist_enable,
    pasv_min_port     => $pasv_min_port,
    pasv_max_port     => $pasv_max_port,
  }
}
