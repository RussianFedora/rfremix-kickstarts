# include Russian Fedora and RPMFusion repos
%include rfremix-repo-not-rawhide.ks

# Fonts and input methods for Russia

%packages
aspell-ru
aspell-uk
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

# vpn for Beeline
NetworkManager-l2tp

%end

%post

cat >> /etc/rc.d/init.d/livesys << EOF

# set system keymaps
localectl set-x11-keymap us,ru pc105 , grp:alt_shift_toggle

EOF

%end
