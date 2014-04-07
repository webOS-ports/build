# Makefile for PreWare
#
# Copyright (C) 2009 by Rod Whitby <rod@whitby.id.au>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

APPDIRS = apps
PTCHDIR = autopatch

.PHONY: index package  upload clobber clean


.PHONY: index
index:  webos-ports-index \
	webos-ports-patches-index \

.PHONY: webos-ports-patches-index
webos-ports-patches-index:
	echo "DUMMY"

.PHONY: webos-ports-index
webos-ports-index: ipkgs/webos-ports/all/Packages ipkgs/webos-ports/i686/Packages ipkgs/webos-ports/armv6/Packages ipkgs/webos-ports/armv7/Packages	

ipkgs/webos-ports/%/Packages: package-appdirs
	rm -rf ipkgs/webos-ports/$*
	mkdir -p ipkgs/webos-ports/$*
	if [ "$*" = "i686" -o "$*" = "all" ] ; then \
	  ( find ${APPDIRS} -mindepth 2 -maxdepth 2 -type d -name ipkgs -print | \
	    xargs -I % find % -name "*_$*.ipk" -print | \
	    xargs -I % rsync -i -a % ipkgs/webos-ports/$* ) ; \
	else \
	  ( find ${APPDIRS} -mindepth 2 -maxdepth 2 -type d -name ipkgs -print | \
	    xargs -I % find % \( -name "*_$*.ipk" -o -name "*_arm.ipk" \) -print | \
	    xargs -I % rsync -i -a % ipkgs/webos-ports/$* ) ; \
	fi	
	TAR_OPTIONS=--wildcards \
	toolchain/ipkg-utils/ipkg-make-index \
		-v -p ipkgs/webos-ports/$*/Packages ipkgs/webos-ports/$*
	gzip -c ipkgs/webos-ports/$*/Packages > ipkgs/webos-ports/$*/Packages.gz

ipkgs/%/Packages:
	rm -rf ipkgs/$*
	mkdir -p ipkgs/$*
	TAR_OPTIONS=--wildcards \
	toolchain/ipkg-utils/ipkg-make-index \
		-v -p ipkgs/$*/Packages ipkgs/$*
	gzip -c ipkgs/$*/Packages > ipkgs/$*/Packages.gz

package: package-appdirs

package-appdirs:
	for f in `find ${APPDIRS} -mindepth 1 -maxdepth 1 -type d -print` ; do \
	  if [ -e $$f/Makefile ]; then \
	    ${MAKE} -C $$f package ; \
	  else \
	    rm -rf $$f ; \
	  fi; \
	done

upload:
	-rsync -avr ipkgs/ preware@ipkg4.preware.org:/home/preware/htdocs/ipkg/feeds/
	#-rsync -avr ipkgs/ preware@ipkg3.preware.org:/home/preware/htdocs/ipkg/feeds/
	-rsync -avr ipkgs/ preware@ipkg2.preware.org:/home/preware/htdocs/ipkg/feeds/
	-rsync -avr ipkgs/ preware@ipkg1.preware.org:/home/preware/htdocs/ipkg/feeds/

.PHONY: alpha alpha-apps
alpha: alpha-apps

alpha-apps:
	${MAKE} APPDIRS="alpha-apps" FEED="WebOS Ports Alpha" webos-ports-index

alpha-upload:
	-rsync -avr ipkgs/webos-ports/ preware@ipkg4.preware.org:/home/preware/htdocs/ipkg/alpha/apps/
	#-rsync -avr ipkgs/webos-ports/ preware@ipkg3.preware.org:/home/preware/htdocs/ipkg/alpha/apps/
	-rsync -avr ipkgs/webos-ports/ preware@ipkg2.preware.org:/home/preware/htdocs/ipkg/alpha/apps/
	-rsync -avr ipkgs/webos-ports/ preware@ipkg1.preware.org:/home/preware/htdocs/ipkg/alpha/apps/

.PHONY: beta beta-apps
beta: beta-apps

beta-apps:
	${MAKE} APPDIRS="beta-apps" FEED="WebOS Ports Beta" webos-ports-index

beta-upload:
	-rsync -avr ipkgs/webos-ports/ preware@ipkg4.preware.org:/home/preware/htdocs/ipkg/beta/apps/
	#-rsync -avr ipkgs/webos-ports/ preware@ipkg3.preware.org:/home/preware/htdocs/ipkg/beta/apps/
	-rsync -avr ipkgs/webos-ports/ preware@ipkg2.preware.org:/home/preware/htdocs/ipkg/beta/apps/
	-rsync -avr ipkgs/webos-ports/ preware@ipkg1.preware.org:/home/preware/htdocs/ipkg/beta/apps/

distclean: clobber
	find toolchain -mindepth 1 -maxdepth 1 -type d -print | \
	xargs -I % ${MAKE} -C % clobber

clobber: clean clobber-appdirs
	rm -rf ipkgs

alpha-clobber:
	${MAKE} APPDIRS="alpha-apps" clobber

beta-clobber:
	${MAKE} APPDIRS="beta-apps" clobber

clean: clean-appdirs
	find . -name "*~" -delete

alpha-clean:
	${MAKE} APPDIRS="alpha-apps" clean

beta-clean:
	${MAKE} APPDIRS="beta-apps" clean

clobber-appdirs:
	find ${APPDIRS} -mindepth 1 -maxdepth 1 -type d -print | \
	xargs -I % ${MAKE} -C % clobber

clean-appdirs:
	find ${APPDIRS} -mindepth 1 -maxdepth 1 -type d -print | \
	xargs -I % ${MAKE} -C % clean
