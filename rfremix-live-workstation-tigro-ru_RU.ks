# rfremix-livecd-desktop-ru_RU.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] ru>

repo --name=google-chrome --baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
repo --name=mailru --baseurl=https://linuxdesktopcloud.mail.ru/rpm/Fedora/default
repo --name=yanex-disk --baseurl=https://repo.yandex.ru/yandex-disk/rpm/stable/$basearch/
repo --name=yandex-browser --baseurl=https://repo.yandex.ru/yandex-browser/rpm/beta/x86_64
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
epiphany
foo2zjs
gimp
gnome-packagekit-common
gparted
koji
libappindicator-gtk3
mock-configs-rfremix
mosh
mpv
rpm-build
rpmdevtools
rpmlint
#shutter
skypeforlinux
system-config-printer
telegram-desktop
tilix
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

# enable external repos
repos=$(rpm -ql rfremix-config-external-repos | grep "\.repo$" | awk -F/ '{ print $NF }')

for i in $repos; do
    if [ -f /etc/yum.repos.d/$i ]; then
        sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/$i
    fi
done

cat >> /etc/rc.d/init.d/livesys << EOF
# add us,ru layouts by default
cat > /usr/share/glib-2.0/schemas/org.gnome.desktop.input-sources.gschema.override << FOE
[org.gnome.desktop.input-sources]
sources=[('xkb', 'us'), ('xkb', 'ru')]
xkb-options=['grp:alt_shift_toggle,grp_led:scroll']
FOE

sed -i \
  "s@favorite-apps=.*@favorite-apps=['chromium-browser.desktop', 'evolution.desktop', 'rhythmbox.desktop', 'empathy.desktop', 'shotwell.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'gnome-tweak-tool.desktop', 'shutter.desktop', 'com.gexperts.Terminix.desktop', 'org.baedert.corebird.desktop', 'anaconda.desktop']@g" \
  /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override

glib-compile-schemas /usr/share/glib-2.0/schemas

EOF

%end

