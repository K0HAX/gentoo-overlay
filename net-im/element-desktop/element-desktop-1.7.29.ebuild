# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg

DESCRIPTION="A glossy Matrix collaboration client for desktop"
HOMEPAGE="https://element.io"
SRC_URI="https://github.com/vector-im/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/vector-im/element-desktop/archive/v${PV}.tar.gz -> element-desktop-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="+emoji"

RESTRICT="network-sandbox"

RDEPEND="!net-im/element-desktop-bin
	app-accessibility/at-spi2-atk:2
	app-crypt/libsecret
	dev-db/sqlcipher
	dev-libs/atk
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
	<net-libs/nodejs-16
	net-print/cups
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXScrnSaver
	x11-libs/pango
	x11-misc/snixembed
	emoji? ( media-fonts/noto-emoji )"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/yarn
	virtual/rust"

QA_PREBUILT="
	/opt/Element/chrome-sandbox
	/opt/Element/element-desktop
	/opt/Element/libEGL.so
	/opt/Element/libGLESv2.so
	/opt/Element/libffmpeg.so
	/opt/Element/libvk_swiftshader.so
	/opt/Element/swiftshader/libEGL.so
	/opt/Element/swiftshader/libGLESv2.so"

src_prepare() {
	default
	yarn install || die
}

src_compile() {
	mkdir defcfg
	cp element.io/release/config.json defcfg/
	yarn run fetch --importkey || die
	yarn run fetch --cfgdir 'defcfg' || die
	yarn build:native || die
	yarn build || die
}

src_install() {
	unpack dist/${PN}_${PV}_amd64.deb
	tar -xvf data.tar.xz || die

#	./node_modules/asar/bin/asar.js p webapp opt/Element/resources/webapp.asar || die
	mv usr/share/doc/${PN} usr/share/doc/${PF} || die
	gunzip usr/share/doc/${PF}/changelog.gz || die

	insinto /
	doins -r usr
	doins -r opt
	local f
	for f in ${QA_PREBUILT}; do
		fperms +x "${f}"
	done
	dosym ../../opt/Element/${PN} /usr/bin/${PN}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	elog "Since upgrading Element to Electron 8 it uses StatusNotifierItem"
	elog "for displaying the tray icon."
	elog "Some popular status bars do not support the new API."
	elog
	elog "If you have problems with showing the tray icon, consider installing"
	elog "x11-misc/snixembed."
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
