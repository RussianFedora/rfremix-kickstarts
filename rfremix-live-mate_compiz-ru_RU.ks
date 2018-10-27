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
rfremix-release-matecompiz
gparted
%end

