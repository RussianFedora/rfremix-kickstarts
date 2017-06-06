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
cat >> /etc/rc.d/init.d/livesys << EOF

# Fix display Installer Icon on Desktop
chmod +x /home/liveuser/Desktop/liveinst.desktop

EOF

%end
