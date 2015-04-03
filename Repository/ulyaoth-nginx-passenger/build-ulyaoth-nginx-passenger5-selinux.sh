arch="$(uname -m)"
buildarch="$(uname -m)"

if [ "$arch" == "i686" ]
then
arch="i386"
fi

yum install -y policycoreutils-python checkpolicy selinux-policy-devel
useradd ulyaoth
su ulyaoth -c "rpmdev-setuptree"
cd /home/ulyaoth/
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx-passenger/SELinux/ulyaoth-nginx-passenger5.txt"
mkdir -p /usr/share/selinux/packages/ulyaoth-nginx-passenger5
cd /usr/share/selinux/packages/ulyaoth-nginx-passenger5
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx-passenger/SELinux/ulyaoth-nginx-passenger5.fc
wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx-passenger/SELinux/ulyaoth-nginx-passenger5.te
make -f /usr/share/selinux/devel/Makefile
cp /usr/share/selinux/packages/ulyaoth-nginx-passenger5/ulyaoth-nginx-passenger5.pp /home/ulyaoth/rpmbuild/SOURCES/
chown -R ulyaoth:ulyaoth /home/ulyaoth/rpmbuild/SOURCES/
cd /home/ulyaoth/rpmbuild/SPECS
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-nginx-passenger/SPECS/ulyaoth-nginx-passenger5-selinux.spec"
if [ "$arch" != "x86_64" ]
then
sed -i '/BuildArch: x86_64/c\BuildArch: '"$buildarch"'' ulyaoth-nginx-passenger5-selinux.spec
fi

yum-builddep -y /home/ulyaoth/rpmbuild/SPECS/ulyaoth-nginx-passenger5-selinux.spec
su ulyaoth -c "rpmbuild -bb ulyaoth-nginx-passenger5-selinux.spec"
cp /home/ulyaoth/rpmbuild/RPMS/x86_64/* /root/
cp /home/ulyaoth/rpmbuild/RPMS/i686/* /root/
cp /home/ulyaoth/rpmbuild/RPMS/i386/* /root/
rm -rf /home/ulyaoth/rpmbuild/
rm -rf /home/ulyaoth/ulyaoth-*
rm -rf /root/build-ulyaoth-nginx-passenger5-selinux.sh