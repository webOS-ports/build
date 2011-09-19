#!/bin/sh

export DISPLAY=${DISPLAY:-:0.0}

NAME=debian-squeeze-chroot

APPID=org.webosinternals.${NAME}

APPDIR=/media/cryptofs/apps/usr/palm/applications/${APPID}

XTERM=/media/cryptofs/apps/usr/palm/applications/org.webosinternals.xterm/bin/xterm

${XTERM} -display ${DISPLAY} -maximize -e "sh -x ${APPDIR}/bin/chroot-wrapper.sh" &
