Create RFRemix Live Images
==========================

Cloning
=======

* git clone -b f25/master --recurse-submodules git://github.com/RussianFedora/rfremix-kickstarts.git

Building Live Images
====================

```
sudo ./create-live 

Create RFRemix Live images based on Fedora 25 package base
from internet.

create-live <imagename> <i686|x86_64|all> <version>
	-c - Cinnamon LiveCD
	-g - Workstation (with GNOME) LiveCD
	-k - KDE LiveCD
	-x - XFCE LiveCD
	-l - LXDE LiveCD
	-m - MATE LiveCD
	-a - ALL Images
```

Building Install Images
=======================

```
XZ_DEFAULTS=--memlimit-compress=3700MiB /usr/bin/pungi \
	-c rfremix-install-workstation.ks \
	--installpkgs fedora-productimg-workstation \
	--ver 25 --variant Workstation --family RFRemix
```

```
XZ_DEFAULTS=--memlimit-compress=3700MiB /usr/bin/pungi \
	-c rfremix-install-server.ks \
	--installpkgs fedora-productimg-server \
	--ver 25 --variant Server --family RFRemix
```
