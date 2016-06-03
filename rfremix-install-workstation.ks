repo --name=fedora --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-24&arch=$basearch --excludepkgs=fedora-productimg-cloud,fedora-productimg-server
repo --name=fedora-source --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-source-24&arch=$basearch --excludepkgs=fedora-productimg-cloud,fedora-productimg-server
repo --name=fedora-updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f24&arch=$basearch --excludepkgs=fedora-productimg-cloud,fedora-productimg-server
repo --name=fedora-updates-source  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-source-f24&arch=$basearch --excludepkgs=fedora-productimg-cloud,fedora-productimg-server

# RPMFusion Repos
repo --name=rpmfusion-free --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-22&arch=$basearch
repo --name=rpmfusion-free-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-23&arch=$basearch
repo --name=rpmfusion-nonfree --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-22&arch=$basearch --exclude *nvidia*
repo --name=rpmfusion-nonfree-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-23&arch=$basearch --exclude *nvidia*
repo --name=rpmfusion-free-source --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-source-22&arch=$basearch
repo --name=rpmfusion-nonfree-source --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-source-22&arch=$basearch
repo --name=rpmfusion-free-updates-source --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-source-23&arch=$basearch
repo --name=rpmfusion-nonfree-updates-source --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-source-23&arch=$basearch

# Russian Fedora Repos
repo --name=russianfedora-branding --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=branding-fedora-24&arch=$basearch --excludepkgs=fedora-release*
repo --name=russianfedora-branding-updates --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=branding-fedora-updates-released-24&arch=$basearch --excludepkgs=fedora-release*
repo --name=russianfedora-free --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=free-fedora-24&arch=$basearch
repo --name=russianfedora-free-updates --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=free-fedora-updates-released-24&arch=$basearch
repo --name=russianfedora-nonfree --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=nonfree-fedora-24&arch=$basearch --exclude java*
repo --name=russianfedora-nonfree-updates --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=nonfree-fedora-updates-released-24&arch=$basearch --exclude java*
repo --name=russianfedora-fixes --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=fixes-fedora-24&arch=$basearch
repo --name=russianfedora-fixes-updates --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=fixes-fedora-updates-released-24&arch=$basearch

repo --name=russianfedora-branding-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=branding-fedora-source-24&arch=$basearch --excludepkgs=fedora-release*
repo --name=russianfedora-branding-updates-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=branding-fedora-updates-released-source-24&arch=$basearch --excludepkgs=fedora-release*
repo --name=russianfedora-fixes-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=fixes-fedora-source-24&arch=$basearch
repo --name=russianfedora-fixes-updates-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=fixes-fedora-updates-released-source-24&arch=$basearch
repo --name=russianfedora-free-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=free-fedora-source-24&arch=$basearch
repo --name=russianfedora-free-updates-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=free-fedora-updates-released-source-24&arch=$basearch
repo --name=russianfedora-nonfree-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=nonfree-fedora-source-24&arch=$basearch
repo --name=russianfedora-nonfree-updates-source --mirrorlist=http://mirrors.rfremix.ru/mirrorlist?repo=nonfree-fedora-updates-released-source-24&arch=$basearch

%include spin-kickstarts/fedora-workstation-packages.ks

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
-astronomy-bookmarks
-generic*

# core
kernel*

# Things needed for installation
@anaconda-tools
-fedora-productimg-cloud
-fedora-productimg-server
fedora-productimg-workstation
@rfremix-workstation-product
%end
