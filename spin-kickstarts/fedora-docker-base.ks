# See docker-base-common.ks for details on how to hack on docker image kickstarts
# This base is a standard Fedora image with python3 and dnf

%include fedora-docker-common.ks

%packages --excludedocs --instLangs=en --nocore
rootfiles
tar # https://bugzilla.redhat.com/show_bug.cgi?id=1409920
vim-minimal
dnf
dnf-yum  # https://fedorahosted.org/fesco/ticket/1312#comment:29
sssd-client

%end

%post --erroronfail --log=/root/anaconda-post.log

# remove some extraneous files
rm -rf /var/cache/dnf/*
echo "Exit code l20: $?"
rm -rf /tmp/*
echo "Exit code l22: $?"

#Mask mount units and getty service so that we don't get login prompt
systemctl mask systemd-remount-fs.service dev-hugepages.mount sys-fs-fuse-connections.mount systemd-logind.service getty.target console-getty.service
echo "Exit code l26: $?"

# https://bugzilla.redhat.com/show_bug.cgi?id=1343138
# Fix /run/lock breakage since it's not tmpfs in docker
# This unmounts /run (tmpfs) and then recreates the files
# in the /run directory on the root filesystem of the container
umount /run
echo "Exit code l33: $?"
systemd-tmpfiles --create --boot
echo "Exit code l35: $?"

%end
