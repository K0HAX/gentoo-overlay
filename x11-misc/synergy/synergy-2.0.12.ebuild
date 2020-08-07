# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils unpacker xdg-utils

DESCRIPTION="Lets you easily share a single mouse and keyboard between multiple computers"
HOMEPAGE="https://symless.com/synergy https://github.com/symless/synergy-core"

SRC_URI="synergy_2.0.12.beta_b1705+e5daaeda_amd64.deb"

LICENSE="synergy-EULA"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="libressl"

COMMON_DEPEND="
	net-misc/curl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXtst
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"

RDEPEND="
	${COMMON_DEPEND}
"

QA_PREBUILT="*"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} and move it to"
	einfo "your distfiles directory:"
	einfo
	einfo "  https://members.symless.com/synergy/downloads/list/s2"
	einfo
}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	rm -rf lib || die
	rm -rf usr/lib || die
	gunzip usr/share/doc/synergy/changelog.gz

	insinto /
	keepdir /var/lib/synergy
	keepdir /var/log/synergy
	keepdir /etc/synergy

	dobin usr/bin/synergy-core
	dobin usr/bin/synergy-tray
	dobin usr/bin/synergy-config
	dobin usr/bin/synergy-service

	dodoc usr/share/doc/synergy/copyright
	dodoc usr/share/doc/synergy/changelog

	insinto /usr/share/icons/
	doins usr/share/icons/synergy.svg
	insinto /usr/share/applications/
	doins usr/share/applications/synergy.desktop

	fperms 0777 /var/log/synergy || die
	fperms 0777 /var/lib/synergy || die
	fperms 0777 /etc/synergy || die
	fperms 0755 /usr/bin/synergy-core || die
	fperms 0755 /usr/bin/synergy-tray || die
	fperms 0755 /usr/bin/synergy-config || die
	fperms 0755 /usr/bin/synergy-service || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
