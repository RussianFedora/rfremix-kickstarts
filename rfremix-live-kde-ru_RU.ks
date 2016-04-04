# rfremix-livecd-kde-ru_RU.ks
#
# Maintainer(s):
# - Arkady L. Shane <ashejn [AT] russianfedora [DOT] ru>

%include spin-kickstarts/fedora-live-kde.ks
%include rfremix-live-base-ru_RU.ks

lang ru_RU.UTF-8
keyboard ru
timezone Europe/Moscow

%packages
-kde-i18n-Russian
kde-l10n-ru
kde-l10n-kk
kde-l10n-uk

kde-partitionmanager

# vpn for Beeline
plasma-nm-l2tp

%end

%post
# make kdm russian
if [ -f /etc/kde/kdm/kdmrc ]; then
        if [ "\`echo \$LANG | awk -F_ '{print \$1}'\`" == "ru" ]; then
                sed -i 's!#Language=de_DE!Language=ru_RU!' /etc/kde/kdm/kdmrc
        fi
fi

%end
