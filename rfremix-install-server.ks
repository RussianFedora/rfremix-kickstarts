# Kickstart file for composing the "Fedora" spin of Fedora (rawhide)
# Maintained by the Fedora Release Engineering team:
# https://fedoraproject.org/wiki/ReleaseEngineering
# mailto:rel-eng@lists.fedoraproject.org

# Use a part of 'iso' to define how large you want your isos.
# Only used when composing to more than one iso.
# Default is 695 (megs), CD size.
# Listed below is the size of a DVD if you wanted to split higher.
#part iso --size=4998

# Add the repos you wish to use to compose here.  At least one of them needs group data.

# Only uncomment repo commands in one of the two following sections.
# Because the install kickstart doesn't use the updates repo and does 
# use the source repo, we can't just include fedora-repo.ks

# In the master branch the rawhide repo commands should be uncommented.
repo --name=rawhide --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide&arch=$basearch
repo --name=rawhide-source  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide-source&arch=$basearch

# RPMFusion Repos
repo --name=rpmfusion-free --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-rawhide&arch=$basearch
repo --name=rpmfusion-nonfree --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-rawhide&arch=$basearch --exclude *nvidia*
repo --name=rpmfusion-free-source --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-source-rawhide&arch=$basearch
repo --name=rpmfusion-nonfree-source --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-source-rawhide&arch=$basearch --exclude *nvidia*

# Russian Fedora Repos
repo --name=russianfedora-free --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=free-fedora-rawhide&arch=$basearch  --exclude russianfedora*
repo --name=russianfedora-nonfree --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=nonfree-fedora-rawhide&arch=$basearch --exclude java*sun*
repo --name=russianfedora-fixes --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=fixes-fedora-rawhide&arch=$basearch
repo --name=russianfedora-branding --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=branding-fedora-rawhide&arch=$basearch

repo --name=russianfedora-fixes-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=fixes-fedora-source-rawhide&arch=$basearch
repo --name=russianfedora-free-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=free-fedora-source-rawhide&arch=$basearch
repo --name=russianfedora-nonfree-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=nonfree-fedora-source-rawhide&arch=$basearch
repo --name=russianfedora-branding-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=branding-fedora-source-rawhide&arch=$basearch

# In non-master branches the fedora repo commands should be uncommented
#repo --name=fedora --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
#repo --name=fedora-source  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-source-$releasever&arch=$basearch

# Package manifest for the compose.  Uses repo group metadata to translate groups.
# (default groups for the configured repos are added by --default)
# @base got renamed to @standard, but @base is still included by default by pungi.
%packages --default

# pungi is an inclusive depsolver so that multiple packages are brought 
# in to satisify dependencies and we don't always want that. So we  use
# an exclusion list to cut out things we don't want

-kernel*debug*
-kernel-kdump*
-kernel-tools*
-syslog-ng*
-astronomy-bookmarks
-generic*
-GConf2-dbus*
-bluez-gnome
# Periods cause problems in paterns, so replace with *s
-java-1*8*0-openjdk
-community-mysql*
-jruby*

# core
kernel*
dracut-*

# Desktops

## common stuff
@base-x
@guest-agents
@standard
@core
@input-methods
@multimedia
@hardware-support
@admin-tools
@basic-desktop

# Workstation
@eclipse
@development-libs
@development-tools
@c-development
@rpm-development-tools
@fedora-packager
@virtualization
@web-server
@mongodb
@perl-web
@php
@python-web
@rubyonrails
@mysql
@sql-server
@design-suite
@jbossas

# Things needed for installation
@anaconda-tools

# Langpacks
autocorr-*
eclipse-nls-*
hunspell-*
hyphen-*
calligra-l10n-*
kde-l10n-*
libreoffice-langpack-*
man-pages-*
mythes-*
-gimp-help-*

# Removals
-PackageKit-zif
-zif
%end
