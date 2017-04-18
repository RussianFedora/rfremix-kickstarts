# Like the Cloud Base image, but tuned for vagrant.  Enable
# the vagrant user, disable cloud-init.

%include rfremix-cloud-base.ks

services --disabled=cloud-init,cloud-init-local,cloud-config,cloud-final

# So, to be clear, this gaping security hole is an integral part of how
# Vagrant works - These images are _not_ supposed to be run in any public-
# Internet facing way - They are for use on developer setups, almost always
# with NAT
user --name=vagrant --password=vagrant

# Suggestion from @purpleidea that most/many vagrant boxes also set root PW
# to "vagrant" for ease of use.  Again, see comments above.
rootpw vagrant

# The addition of the net.ifnames=0 and biosdevnames=0 option ensures that
# even on VirtualBox virt, we get a primary network device with "eth0" as the name
# This simplifies things and allows a single disk image for both supported Vagrant
# platforms (virtualbox and kvm)
bootloader --timeout=1 --append="no_timer_check console=tty1 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0"

%packages
# The default koji Vagrantfile configuration uses rsync to sync files between
# the vagrant host and the guest.  It uses yum to verify that rsync is present
# and/or install it if it is not.  It will fail without adding the yum compat
# layer for dnf
# TODO: Teach vagrant about dnf
dnf-yum
# rsync gets installed when the Vagrant box is first launched on the
# users setup. This can actually take a bit of time.  Just fold it
# in to the base box disk image
rsync
%end

%post --erroronfail

# Work around cloud-init being both disabled and enabled; need
# to refactor to a common base.
systemctl mask cloud-init cloud-init-local cloud-config cloud-final

# Vagrant setup
sed -i 's,Defaults\\s*requiretty,Defaults !requiretty,' /etc/sudoers
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant-nopasswd
sed -i 's/.*UseDNS.*/UseDNS no/' /etc/ssh/sshd_config
mkdir -m 0700 -p ~vagrant/.ssh
cat > ~vagrant/.ssh/authorized_keys << EOKEYS
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDd26awXafGOx5J/+uXd5GLEo/VQXVT3HsBk3NIMHZhMd0W6alFMEFLlDXqCJiRhFm3CNShjo6qQuK4P2z4aZjvgmnm3MF8nOVd5zXuFnJhgAe5ZUMbnNaLzJwItxrRW8AZqK+u5y1sjqon/T1wl9MVITwEbp/uwFOyTBfxYv4WH2e+EQYlIkuQibzbQL4P0UDCRqpFRHm6BHQikMeyIrt2cnrKlo10c2m/0Pqx11s7qGS4P1VABd+8qs/Jq3XO9p/YW9eArfAM2Lbv+xCbTbtQ6bj2pZ3oONA5Xh1OCDcffewML5uZnvtm7i/HgkldTDRNsqoDEAhRHrqKssiTDPuQg3jJzkTIS8ScTvt/Uqti+t2FV5hu/wRvWKnaO2BNudkotW+7sWO43Hbx690wAAjAgR69qr/ZK01+IGiUCAlkaH3i2Cp1M/+h0U7lPpOIJbYwNyjWJ9HTq+BJvJCIc8h49BKcvk3QvXBgPjRQUw4dPmTv30pRpVI07MXHXVq6NrsVcxFkNRmZ3G6G9reMoFtwq5gi7+YjNEOpCn4c+PrCIERA0tNm0m5hP/Z9StOzHM36sM7AiNBZLUjTRbuUFQ18a3h7I9Eg4+8ubqCBSqN+2I+KVcbFSkHSJFlSmBa5sdkj8DcvI1+RGrepk6QWCHFFdH1jQpJHRSXcmO1C+FYtaQ== ashejn@yandex-team.ru
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOKEYS
chmod 600 ~vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant ~vagrant/.ssh/

# Further suggestion from @purpleidea (James Shubin) - extend key to root users as well
mkdir -m 0700 -p /root/.ssh
cp /home/vagrant/.ssh/authorized_keys /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chown -R root:root /root/.ssh

%end
