# from https://endoyuta.com/2016/05/04/amazon-linux-ffmpeg%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB/

$ wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
$ sudo rpm -ivh rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm

$sudo vim /etc/yum.repos.d/centos.repo

# そのまま書く
[base]
name=CentOS-6 - Base
mirrorlist=http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=os
enabled=0
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6
# 書く部分ここまで

sudo yum install -y --enablerepo=base ffmpeg-devel
