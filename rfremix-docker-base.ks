# rfremix-docker-base.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] pro>

%include spin-kickstarts/fedora-docker-base.ks

%packages
-fedora-release
rfremix-release
%end

%post --erroronfail --log=/root/anaconda-post.log
echo "Import RPM GPG key"
releasever=$(rpm -q --qf '%{version}\n' rfremix-release)
basearch=$(uname -i)
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-russianfedora-*
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-*-$releasever
%end
