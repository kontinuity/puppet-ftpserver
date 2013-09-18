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
  $anonymous_enable 	= 'NO',
  $write_enable		= 'YES',
  $ftpd_banner 		= 'FTP Server',
  $chroot_local_user 	= 'YES',
  $chroot_list_enable   = 'YES',
  $userlist_enable	= 'NO',
  $chroot_list_file     = '/etc/vsftpd/chroot_list', 
  $ftpuserrootdirs	= ['/data',
			   '/data/ftp'],
) {

  group { 'ftpusers':
    ensure	=> present,
  }

  file { $ftpuserrootdirs:
    ensure	=> 'directory',
  }

  create_resources('ftpserver::users', hiera('ftpserver::users', []))


  file { '/etc/vsftpd':
    ensure	=> 'directory',
  }

  file { $chroot_list_file:
    content	=> template('ftpserver/vsftpd.chroot_list.erb'),
    require	=> File['/etc/vsftpd'],
  }

  class { 'vsftpd':
    anonymous_enable  => $anonymous_enable,
    write_enable      => $write_enable,
    ftpd_banner       => $ftpd_banner,
    chroot_local_user => $chroot_local_user,
    chroot_list_enable=> $chroot_list_enable,
    chroot_list_file  => $chroot_list_file, 
    userlist_enable   => $userlist_enable,
  }
}
