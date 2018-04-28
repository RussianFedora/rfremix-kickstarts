# Fedora Atomic Host is the Fedora version of the "Atomic Host" pattern
# from [Project Atomic](http://www.projectatomic.io/).

# This kickstart is used for cloud/virt images, and uses cloud-init
# to bootstrap authentication, just like Fedora Cloud Base.  (Also note the
# fedora-atomic-vagrant.ks kickstart inherits from this).

# One very important thing to understand is that this image contains the same
# OSTree commit as will be used on bare metal installations - Fedora Atomic Host
# also has an ISO. One difference though is that cloud-init isn't enabled for
# bare metal. When processing this kickstart then, Anaconda isn't actually
# installing packages - it's just replicating a "pre-assembled" tree from
# rpm-ostree.

# Basically, the `ostreesetup` verb replaces the traditional `%packages`
# section. For example, `rpm-ostree status` can show you the same checksum and
# version from an ISO install and this cloud image - it's the same bits.

text # don't use cmdline -- https://github.com/rhinstaller/anaconda/issues/931
lang en_US.UTF-8
keyboard us
timezone --utc Etc/UTC

auth --useshadow --passalgo=sha512
selinux --enforcing
rootpw --lock --iscrypted locked

# Explicitly disable firewall since cloud providers generally provide
# higher level firewall constructs (i.e. security groups).
firewall --disabled

# console=ttyAMA0 and console=hvc0 as kernel boot parameter to see
# kernel boot messages on serial console as well on aarch64 and
# ppc64le respectively.
# https://pagure.io/atomic-wg/issue/347
bootloader --timeout=1 --append="no_timer_check console=tty1 console=ttyS0,115200n8 console=ttyAMA0 console=hvc0 net.ifnames=0"

network --bootproto=dhcp --device=link --activate --onboot=on
services --enabled=sshd,cloud-init,cloud-init-local,cloud-config,cloud-final

zerombr
clearpart --all
# Implement: https://pagure.io/atomic-wg/issue/281
# The bare metal layout currently inherits from fedora server and is in
# https://github.com/rhinstaller/anaconda/blob/master/pyanaconda/installclasses/fedora_atomic_host.py
# However, the disk size is currently just 6GB for the cloud image (defined in pungi-fedora).  So the
# "15GB, rest unallocated" model doesn't make sense.  The Vagrant box is 40GB (apparently a number of
# Vagrant boxes come big and rely on thin provisioning).
# In both cases, it's simplest to just fill all the disk space.
#
# Use reqpart to create hardware platform specific partitions
# https://pagure.io/atomic-wg/issue/299
reqpart --add-boot
part pv.01 --grow
volgroup atomicos pv.01
# Start from 3GB as we did before, since we just need a size.  But we do --grow to fill all space.
logvol / --size=3000 --grow --fstype="xfs" --name=root --vgname=atomicos

# Equivalent of %include fedora-repo.ks
# Pull from the ostree repo that was created during the compose
ostreesetup --nogpg --osname=fedora-atomic --remote=fedora-atomic --url=https://kojipkgs.fedoraproject.org/compose/atomic/repo/ --ref=fedora/28/${basearch}/updates/atomic-host

reboot

%post --erroronfail
# Find the architecture we are on
arch=$(uname -m)

# Set the origin to the "main ref", distinct from /updates/ which is where bodhi writes.
# We want consumers of this image to track the two week releases.
ostree admin set-origin --index 0 fedora-atomic https://kojipkgs.fedoraproject.org/atomic/28/ "fedora/28/${arch}/atomic-host"

# Make sure the ref we're supposedly sitting on (according
# to the updated origin) exists.
ostree refs "fedora-atomic:fedora/28/${arch}/updates/atomic-host" --create "fedora-atomic:fedora/28/${arch}/atomic-host"

# Remove the old ref so that the commit eventually gets
# cleaned up.
ostree refs "fedora-atomic:fedora/28/${arch}/updates/atomic-host" --delete

# delete/add the remote with new options to enable gpg verification
# and to point them at the cdn url
ostree remote delete fedora-atomic
ostree remote add --set=gpg-verify=true --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-28-primary fedora-atomic 'https://dl.fedoraproject.org/atomic/repo/'

# older versions of livecd-tools do not follow "rootpw --lock" line above
# https://bugzilla.redhat.com/show_bug.cgi?id=964299
passwd -l root

# Work around https://bugzilla.redhat.com/show_bug.cgi?id=1193590
cp /etc/skel/.bash* /var/roothome

# Configure docker-storage-setup to resize the partition table on boot
# and extend the root filesystem to fill it.
# https://pagure.io/atomic-wg/issue/343
echo 'GROWPART=true' >> /etc/sysconfig/docker-storage-setup
echo 'ROOT_SIZE=+100%FREE' >> /etc/sysconfig/docker-storage-setup

echo -n "Getty fixes"
# although we want console output going to the serial console, we don't
# actually have the opportunity to login there. FIX.
# we don't really need to auto-spawn _any_ gettys.
sed -i '/^#NAutoVTs=.*/ a\
NAutoVTs=0' /etc/systemd/logind.conf

echo -n "Network fixes"
# initscripts don't like this file to be missing.
cat > /etc/sysconfig/network << EOF
NETWORKING=yes
NOZEROCONF=yes
EOF

# Remove any persistent NIC rules generated by udev
rm -vf /etc/udev/rules.d/*persistent-net*.rules
# And ensure that we will do DHCP on eth0 on startup
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
PERSISTENT_DHCLIENT="yes"
EOF

# Because memory is scarce resource in most cloud/virt environments,
# and because this impedes forensics, we are differing from the Fedora
# default of having /tmp on tmpfs.
echo "Disabling tmpfs for /tmp."
systemctl mask tmp.mount

# Uncomment this if you want to use cloud init but suppress the creation
# of an "ec2-user" account. This will, in the absence of further config,
# cause the ssh key from a metadata source to be put in the root account.
#cat <<EOF > /etc/cloud/cloud.cfg.d/50_suppress_ec2-user_use_root.cfg
#users: []
#disable_root: 0
#EOF

echo "Removing random-seed so it's not the same in every image."
rm -f /var/lib/systemd/random-seed

echo "Packages within this cloud image:"
echo "-----------------------------------------------------------------------"
rpm -qa
echo "-----------------------------------------------------------------------"
# Note that running rpm recreates the rpm db files which aren't needed/wanted
rm -f /var/lib/rpm/__db*

echo "Zeroing out empty space."
# This forces the filesystem to reclaim space from deleted files
dd bs=1M if=/dev/zero of=/var/tmp/zeros || :
rm -f /var/tmp/zeros
echo "(Don't worry -- that out-of-space error was expected.)"

# For trac ticket https://pagure.io/atomic-wg/issue/128
rm -f /etc/sysconfig/network-scripts/ifcfg-ens3

echo "Adding Developer Mode GRUB2 menu item."
/usr/libexec/atomic-devmode/bootentry add

# Disable network service here, as doing it in the services line
# fails due to RHBZ #1369794
/sbin/chkconfig network off

# Anaconda is writing an /etc/resolv.conf from the install environment.
# The system should start out with an empty file, otherwise cloud-init
# will try to use this information and may error:
# https://bugs.launchpad.net/cloud-init/+bug/1670052
truncate -s 0 /etc/resolv.conf

%end
