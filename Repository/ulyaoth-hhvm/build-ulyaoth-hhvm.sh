buildarch="$(uname -m)"
hhvmversion=3.7.3

useradd ulyaoth
cd /home/ulyaoth

if grep -q -i "release 7" /etc/redhat-release
then
yum install -y  http://mirror.nsc.liu.se/fedora-epel/7/$buildarch/e/epel-release-7-5.noarch.rpm
fi

su ulyaoth -c "rpmdev-setuptree"
su ulyaoth -c "wget https://github.com/facebook/hhvm/archive/HHVM-$hhvmversion.tar.gz"
su ulyaoth -c "tar xvzf HHVM-$hhvmversion.tar.gz"
mv /home/ulyaoth/hhvm-HHVM-$hhvmversion /home/ulyaoth/hhvm-$hhvmversion
cd /home/ulyaoth/hhvm-$hhvmversion
su ulyaoth -c "git submodule update --init --recursive"
cd /home/ulyaoth
su ulyaoth -c "tar cvf hhvm-$hhvmversion.tar.gz hhvm-$hhvmversion/"
mv /home/ulyaoth/hhvm-$hhvmversion.tar.gz /home/ulyaoth/rpmbuild/SOURCES/
rm -rf /home/ulyaoth/hhvm-$hhvmversion
rm -rf /home/ulyaoth/HHVM-$hhvmversion.tar.gz
cd /home/ulyaoth/rpmbuild/SPECS/
su ulyaoth -c "wget https://raw.githubusercontent.com/sbagmeijer/ulyaoth/master/Repository/ulyaoth-hhvm/SPECS/ulyaoth-hhvm.spec"

if [ "$arch" != "x86_64" ]
then
sed -i '/BuildArch: x86_64/c\BuildArch: '"$buildarch"'' ulyaoth-hhvm.spec
fi

if grep -q -i "release 22" /etc/fedora-release
then
dnf builddep -y /home/ulyaoth/rpmbuild/SPECS/ulyaoth-hhvm.spec
else
yum-builddep -y /home/ulyaoth/rpmbuild/SPECS/ulyaoth-hhvm.spec
fi

su ulyaoth -c "spectool ulyaoth-hhvm.spec -g -R"
su ulyaoth -c "QA_SKIP_BUILD_ROOT=1 rpmbuild -bb ulyaoth-hhvm.spec"
cp /home/ulyaoth/rpmbuild/RPMS/x86_64/* /root/