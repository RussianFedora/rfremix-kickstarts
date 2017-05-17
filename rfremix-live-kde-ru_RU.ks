# rfremix-livecd-kde-ru_RU.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] ru>

%include spin-kickstarts/fedora-live-kde.ks
%include rfremix-live-base-ru_RU.ks

part / --size=6656

lang ru_RU.UTF-8
keyboard ru
timezone Europe/Moscow

%packages
-kde-i18n-Russian
kde-l10n-ru
kde-l10n-kk
kde-l10n-uk

kde-partitionmanager

@libreoffice
-@kde-office
okular

# kde theme for plymouth
plymouth-theme-breeze

# vpn for Beeline
plasma-nm-l2tp

%end

%post
kde theme for plymouth
/usr/sbin/plymouth-set-default-theme breeze -R
