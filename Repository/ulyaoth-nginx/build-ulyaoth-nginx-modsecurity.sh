useradd ulyaoth
yum install -y pcre pcre-devel libxml2 libxml2-devel curl curl-devel httpd-devel yajl-devel lua-devel lua-static
mkdir -p /etc/nginx/modules
cd /etc/nginx/modules
wget https://www.modsecurity.org/tarball/2.8.0/modsecurity-2.8.0.tar.gz
tar xvf modsecurity-2.8.0.tar.gz
mv modsecurity-2.8.0 modsecurity
rm -rf modsecurity-2.8.0.tar.gz
cd modsecurity
./autogen.sh
./configure --enable-standalone-module
make
cd /etc/nginx/modules
tar cvf modsecurity.tar.gz modsecurity
mv cvf modsecurity.tar.gz /root/rpmbuild/SOURCES/
cd /root
rpmdev-setuptree
cd /root/rpmbuild/SOURCES
wget http://nginx.org/download/nginx-1.6.1.tar.gz
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/logrotate
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/modsecurity.conf
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.conf
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.init
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.service
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.suse.init
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.sysconf
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.upgrade.sh
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.vh.default-modsecurity.conf
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.vh.default.conf
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.vh.example_ssl.conf
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SOURCES/nginx.vh.passenger.conf
cd /root/rpmbuild/SPECS
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SPECS/ulyaoth-nginx-modsecurity.spec
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SPECS/ulyaoth-nginx-passenger.spec
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx/SPECS/ulyaoth-nginx.spec
cd /home/ulyaoth/
chown -R ulyaoth:ulyaoth /etc/nginx/
mv /root/rpmbuild /home/ulyaoth/
chown -R ulyaoth:ulyaoth /home/ulyaoth/rpmbuild
cd /home/ulyaoth/rpmbuild/SPECS
yum-builddep -y ulyaoth-nginx-modsecurity.spec
su ulyaoth -c "rpmbuild -bb ulyaoth-nginx-modsecurity.spec"
rm -rf /home/ulyaoth/rpmbuild/BUILD/*
rm -rf /home/ulyaoth/rpmbuild/BUILDROOT/*
rm -rf /home/ulyaoth/rpmbuild/RPMS/*
rm -rf /home/ulyaoth/rpmbuild/SOURCES/modsecurity.tar.gz
cd /etc/nginx/modules
tar cvf modsecurity.tar.gz modsecurity
mv modsecurity.tar.gz /home/ulyaoth/rpmbuild/SOURCES/
chown -R ulyaoth:ulyaoth /home/ulyaoth/rpmbuild
cd /home/ulyaoth/rpmbuild/SPECS
su ulyaoth -c "rpmbuild -bb ulyaoth-nginx-modsecurity.spec"
cp /home/ulyaoth/rpmbuild/RPMS/x86_64/* /root/