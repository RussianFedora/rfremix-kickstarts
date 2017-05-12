# rfremix-livecd-xfce-ru_RU.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] ru>

%include spin-kickstarts/fedora-live-mate_compiz.ks
%include rfremix-live-base-ru_RU.ks

lang ru_RU.UTF-8
keyboard ru
timezone Europe/Moscow

%packages
gparted
%end

%post
# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Fix display on Desktop
  sed -i '/^Type=/d' /usr/share/applications/liveinst.desktop
fi

if [ ! -d /home/liveuser/Desktop ]; then
    mkdir /home/liveuser/Desktop
fi

cp /usr/share/applications/liveinst.desktop /home/liveuser/Desktop/

%end
