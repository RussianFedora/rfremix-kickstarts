# rfremix-livecd-desktop-ru_RU.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] ru>

%include spin-kickstarts/fedora-live-workstation.ks
%include rfremix-live-base-ru_RU.ks

lang ru_RU.UTF-8
keyboard ru
timezone Europe/Moscow

%packages
gparted
libappindicator-gtk3

# Classic session for GNOME
@rfremix-workstation-product
%end

%post
cat >> /etc/rc.d/init.d/livesys << EOF
# add us,ru layouts by default
cat > /usr/share/glib-2.0/schemas/org.gnome.desktop.input-sources.gschema.override << FOE
[org.gnome.desktop.input-sources]
sources=[('xkb', 'us'), ('xkb', 'ru')]
xkb-options=['grp:alt_shift_toggle,grp_led:scroll']
FOE

## set EvoPop icon and gtk themes by default
#cat > /usr/share/glib-2.0/schemas/org.gnome.desktop.interface.gschema.override <<FOE
#[org.gnome.desktop.interface]
#icon-theme='EvoPop'
#gtk-theme='evopop-gtk-theme'
#FOE

glib-compile-schemas /usr/share/glib-2.0/schemas

EOF

%end

