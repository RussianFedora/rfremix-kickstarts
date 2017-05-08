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
# Fix display on Desktop
sed -i '/^Type=/d' /home/liveuser/Desktop/liveinst.desktop

%end
