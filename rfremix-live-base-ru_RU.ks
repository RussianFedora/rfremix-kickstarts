# include Russian Fedora and RPMFusion repos
%include rfremix-repo-not-rawhide.ks

url --url="http://mirror.yandex.ru/fedora/russianfedora/build/25/$basearch/"

# Fonts and input methods for Russia

%packages
aspell-ru
autocorr-ru
hunspell-ru
hunspell-kk
hunspell-uk
hyphen-ru
hyphen-uk
libreoffice-langpack-ru
libreoffice-langpack-kk
libreoffice-langpack-uk
mythes-ru
mythes-uk

# fonts for Russia
dejavu-sans-fonts
dejavu-sans-mono-fonts
dejavu-serif-fonts
ucs-miscfixed-fonts

# codecs
gstreamer-ffmpeg
gstreamer-plugins-bad-free
gstreamer-plugins-bad-nonfree
gstreamer-plugins-ugly
gstreamer1-libav
gstreamer1-plugins-bad-free
gstreamer1-plugins-ugly

# yes many peoples love flash
flash-plugin

# messangers
telegram-desktop

# should be to feel better
bash-completion
fpaste
gpm
grub-customizer
mc
wget

# avoid theese
-*nvidia*
-freetype-freeworld
-ubuntu-font-family

# configuration
rfremix-config

# repos
rpmfusion-free-release
rpmfusion-nonfree-release
russianfedora-free-release
russianfedora-fixes-release
russianfedora-nonfree-release
russianfedora-branding-release

# drop fedora branding
-fedora-logos*
-fedora-release
-fedora-release-atomichost
-fedora-release-cloud
-fedora-release-server
-fedora-release-workstation
-generic-logos*
-generic-release
-generic-release-notes

# drop p7zip as it does not support cyrillic cp1251 zip files
# new Fedora unzip support it without any patches
-p7zip

# vpn for Beeline
NetworkManager-l2tp

-libcrypt
libcrypt-nss

%end

%post

cat >> /etc/rc.d/init.d/livesys << EOF

# set system keymaps
localectl set-x11-keymap us,ru pc105 , grp:alt_shift_toggle

EOF

%end
