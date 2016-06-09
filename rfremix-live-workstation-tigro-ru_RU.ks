# rfremix-livecd-desktop-ru_RU.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] ru>

%include spin-kickstarts/fedora-live-workstation.ks
%include rfremix-live-base-ru_RU.ks

part / --size=8656

lang ru_RU.UTF-8
keyboard ru
timezone Europe/Moscow

%packages
-transmission*

chromium
chromium-pepper-flash
deluge
gimp
gparted
shutter
skype
telegram-desktop
viber

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
favorite-apps=['chromium-browser.desktop', 'evolution.desktop', 'rhythmbox.desktop', 'shotwell.desktop', 'org.gnome.Nautilus.desktop']
FOE

glib-compile-schemas /usr/share/glib-2.0/schemas

cat >> /etc/rc.d/init.d/livesys << EOF
# add us,ru layouts by default
cat > /usr/share/glib-2.0/schemas/org.gnome.desktop.input-sources.gschema.override << FOE
[org.gnome.desktop.input-sources]
sources=[('xkb', 'us'), ('xkb', 'ru')]
xkb-options=['grp:alt_shift_toggle,grp_led:scroll']
FOE

sed -i '/firefox.desktop/d' /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override
sed -i \
  "s@favorite-apps=.*@favorite-apps=['chromium-browser.desktop', 'evolution.desktop', 'rhythmbox.desktop', 'shotwell.desktop', 'org.gnome.Nautilus.desktop', 'anaconda.desktop']@g" \
  /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override

glib-compile-schemas /usr/share/glib-2.0/schemas

EOF

%end

