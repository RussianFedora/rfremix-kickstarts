# rfremix-livecd-desktop-ru_RU.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] ru>

repo --name=google-chrome --baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
repo --name=mailru --baseurl=https://linuxdesktopcloud.mail.ru/rpm/Fedora/default
repo --name=yanex-disk --baseurl=https://repo.yandex.ru/yandex-disk/rpm/stable/$basearch/
repo --name=yandex-browser --baseurl=https://repo.yandex.ru/yandex-browser/rpm/beta/x86_64
repo --name=dropbox --baseurl=http://linux.dropbox.com/fedora/24/
repo --name virtualbox --baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/24/$basearch
repo --name skype-stable --baseurl=https://repo.skype.com/rpm/stable/

%include spin-kickstarts/fedora-live-workstation.ks
%include rfremix-live-base-ru_RU.ks

part / --size=8656

lang ru_RU.UTF-8
keyboard ru
timezone Europe/Moscow

%packages
-transmission*

chrome-gnome-shell
chromium
chromium-pepper-flash
corebird
deluge
empathy
gimp
gparted
koji
libappindicator-gtk3
mock-configs-rfremix
mpv
rpm-build
rpmdevtools
rpmlint
shutter
skype
skypeforlinux
telegram-desktop
terminix
unrar
viber
vim-enhanced
xchat

# proprietary
VirtualBox-5.1
google-chrome-stable
mail.ru-cloud
nautilus-dropbox
yandex-browser-beta
yandex-disk

# Classic session for GNOME
@rfremix-workstation-product
%end

%post
# set EvoPop icon and gtk themes by default
cat > /usr/share/glib-2.0/schemas/org.gnome.desktop.interface.gschema.override <<FOE
[org.gnome.desktop.interface]
icon-theme='EvoPop'
gtk-theme='Adapta'
text-scaling-factor=0.96999999999999997
FOE

# change firefox to chromium
cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
[org.gnome.shell]
favorite-apps=['chromium-browser.desktop', 'evolution.desktop', 'rhythmbox.desktop', 'empathy.desktop', 'shotwell.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'gnome-tweak-tool.desktop', 'shutter.desktop', 'com.gexperts.Terminix.desktop', 'org.baedert.corebird.desktop']
FOE

glib-compile-schemas /usr/share/glib-2.0/schemas

cat >> /etc/skel/.config/mimeapps.list << FOE
[Default Applications]
x-scheme-handler/http=chromium-browser.desktop
application/x-extension-htm=chromium-browser.desktop
application/x-extension-html=chromium-browser.desktop
application/x-extension-shtml=chromium-browser.desktop
application/x-extension-xht=chromium-browser.desktop
application/x-extension-xhtml=chromium-browser.desktop
application/xhtml+xml=chromium-browser.desktop
text/html=chromium-browser.desktop
x-scheme-handler/chrome=chromium-browser.desktop
x-scheme-handler/ftp=chromium-browser.desktop
x-scheme-handler/https=chromium-browser.desktop

[Added Associations]
application/x-extension-htm=chromium-browser.desktop;
application/x-extension-html=chromium-browser.desktop;
application/x-extension-shtml=chromium-browser.desktop;
application/x-extension-xht=chromium-browser.desktop;
application/x-extension-xhtml=chromium-browser.desktop;
application/xhtml+xml=chromium-browser.desktop;
text/html=chromium-browser.desktop;
x-scheme-handler/chrome=chromium-browser.desktop;
x-scheme-handler/ftp=chromium-browser.desktop;
x-scheme-handler/https=chromium-browser.desktop;
FOE

cat > /etc/yum.repos.d/google-chrome.repo << FOE
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
FOE

cat > /etc/yum.repos.d/mail.ru-cloud.repo << FOE
[mail.ru-cloud]
name=mail.ru-cloud repo
baseurl=https://linuxdesktopcloud.mail.ru/rpm/Fedora/default
gpgcheck=1
gpgkey=https://linuxdesktopcloud.mail.ru/mail.ru-cloud.gpg
enabled=1
FOE

cat > /etc/yum.repos.d/yandex-disk.repo << FOE
[yandex-disk]
name=Yandex Disk
failovermethod=priority
baseurl=http://dist.yandex.ru/repo.yandex.ru/yandex-disk/rpm/stable/\$basearch/
enabled=1
metadata_expire=1d
gpgcheck=1
gpgkey=http://dist.yandex.ru/repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG
skip_if_unavailable=1
FOE

cat > /etc/yum.repos.d/yandex-browser.repo << FOE
[yandex-browser]
name=Yandex Browser
baseurl=http://repo.yandex.ru/yandex-browser/rpm/beta/x86_64
enabled=1
gpgcheck=1
gpgkey=https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG
skip_if_unavailable=1
FOE

cat > /etc/yum.repos.d/dropbox.repo << FOE
[Dropbox]
name=Dropbox Repository
baseurl=http://linux.dropbox.com/fedora/24/
gpgkey=https://linux.dropbox.com/fedora/rpm-public-key.asc
skip_if_unavailable=1
FOE

cat > /etc/yum.repos.d/virtualbox.repo << FOE
[virtualbox]
name=Fedora \$releasever - \$basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/24/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://www.virtualbox.org/download/oracle_vbox.asc
FOE

cat > /etc/yum.repos.d/skype-stable.repo << FOE
[skype-linux]
name=skype (stable)
baseurl=https://repo.skype.com/rpm/stable/
enabled=1
gpgcheck=1
gpgkey=https://repo.skype.com/data/SKYPE-GPG-KEY
FOE

cat >> /etc/rc.d/init.d/livesys << EOF
# add us,ru layouts by default
cat > /usr/share/glib-2.0/schemas/org.gnome.desktop.input-sources.gschema.override << FOE
[org.gnome.desktop.input-sources]
sources=[('xkb', 'us'), ('xkb', 'ru')]
xkb-options=['grp:alt_shift_toggle,grp_led:scroll']
FOE

sed -i '/firefox.desktop/d' /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override
sed -i \
  "s@favorite-apps=.*@favorite-apps=['chromium-browser.desktop', 'evolution.desktop', 'rhythmbox.desktop', 'empathy.desktop', 'shotwell.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'gnome-tweak-tool.desktop', 'shutter.desktop', 'com.gexperts.Terminix.desktop', 'org.baedert.corebird.desktop' 'anaconda.desktop']@g" \
  /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override

glib-compile-schemas /usr/share/glib-2.0/schemas

EOF

%end

