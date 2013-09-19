puppet-ftpserver
===================

Puppet module to install 

For more information using this tool: 

Parameters
-------------
All parameters are read from hiera, defaults in init.pp. 



Classes
-------------
ftpserver
ftpserver::users



Dependencies
-------------
thias/vsftpd
puppetlabs/firewall module

firewall open ports ( 20,21 and 10000-10200 ). Range 10000-10200 can be adjusted in with the parameters ftpserver::pasv_min_port and ftpserver::pasv_max_port


Examples
-------------

Hiera_yaml example
```
 ftpserver::ftpd_banner: 'FTP Server'
 ftpserver::ftpusers:
   user1:
     comment: "FTP User 1"
     home: "/data/ftp/user1"
     password: "$1$hGAo41XE$y.BLWugfVr1.mLvkuLbRN/" 
   user2:
     comment: "FTP User 2"
     home: "/data/ftp/user2"
     password: "$1$hGAo41XE$y.BLWugfVr1.mLvkuLbRN/" 
```

Create password hashes using command: "openssl passwd -1"

Puppet code
```
class { ftpserver: }
```
Result
-------------
Working FTP server (for passive connections) with iptables firewall settings

Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.

The module has been tested on:
- Ubuntu 12.04LTS 
- CentOS 6.3
 

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

