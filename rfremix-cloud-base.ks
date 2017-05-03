# rfremix-cloud-base.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] pro>

%include spin-kickstarts/fedora-cloud-base.ks
%include rfremix-repo-not-rawhide.ks

%packages
-@^cloud-server-environment
@^rfremix-cloud-server-environment
%end

%post --erroronfail --log=/root/anaconda-post.log
echo "Import RPM GPG key"
releasever=$(rpm -q --qf '%{version}\n' rfremix-release)
basearch=$(uname -i)
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-russianfedora-*
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-*-$releasever
%end
