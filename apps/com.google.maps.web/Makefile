NAME = google-maps-web
TITLE = Google Maps web application
APP_ID = com.google.maps.web
VERSION = 1.1.0
TYPE = Application
CATEGORY = Location And Travel
HOMEPAGE = https://github.com/webOS-ports/web-apps
ICON = https://raw.githubusercontent.com/webOS-ports/web-apps/master/com.google.maps.web/icon.png
DESCRIPTION = Google Maps website packaged as webOS application
CHANGELOG = \
    1.0.0: Initial public release.

LICENSE = GPL-3.0

SRC_GIT = git://github.com/webOS-ports/web-apps.git

.PHONY: package
package: ipkgs/${APP_ID}_${VERSION}_all.ipk
include ../../support/package.mk

include ../../support/download.mk

.PHONY: unpack
unpack: build/.unpacked-${VERSION}

build/.unpacked-${VERSION}: ${DL_DIR}/${NAME}-${VERSION}.tar.gz
	rm -rf build
	mkdir -p build/src
	mkdir -p build/src-predeploy
	tar -C build/src-predeploy -xf ${DL_DIR}/${NAME}-${VERSION}.tar.gz
	# cd build/src-predeploy && node enyo/tools/deploy.js
	cp -r build/src-predeploy/${APP_ID}/* build/src
	rm -rf build/src/bin build/src/*.script
	touch $@

.PHONY: build
build: build/.built-${VERSION}

build/.built-${VERSION}: build/all.built-${VERSION}
	touch $@

build/%.built-${VERSION}: build/.unpacked-${VERSION}
	rm -rf build/$*
	mkdir -p build/$*/usr/palm/applications/${APP_ID}
	cp -r build/src/* build/$*/usr/palm/applications/${APP_ID}/
	touch $@

clobber::
	rm -rf build git
