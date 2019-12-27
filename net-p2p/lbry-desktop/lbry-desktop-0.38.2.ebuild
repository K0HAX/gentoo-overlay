# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A browser for the LBRY network, a digital marketplace controlled by its users."
HOMEPAGE="https://lbry.com/"

inherit eutils gnome2-utils

# https://github.com/lbryio/lbry-desktop/archive/v0.38.2.tar.gz
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/lbryio/lbry-desktop.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/lbryio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""
REQUIRED_USE=""

DEPEND="sys-devel/binutils:*
	net-libs/nodejs
	sys-apps/yarn
	gnome-base/gconf
	x11-libs/libnotify
	dev-libs/libappindicator:*
	x11-libs/libXtst
	dev-libs/nss"
RDEPEND="${DEPEND}"

DESTINATION="/"

src_prepare() {
	default

	yarn install || die "Yarn module installation failed"
}

src_compile() {
	yarn run build || die "Build failed"

	"${S}"/node_modules/.bin/electron-builder --linux --x64 || die "Building failed"
}

src_install() {
	ar x "${S}"/dist/electron/LBRY*.deb
	tar xvf data.tar.xz

	mv usr/share/doc/lbry usr/share/doc/${PF}
	gunzip usr/share/doc/${PF}/changelog.gz
	insinto ${DESTINATION}
	doins -r usr
	doins -r opt
	fperms +x /opt/LBRY/lbry
	dosym ${DESTINATION}/opt/LBRY/lbry ${DESTINATION}/usr/bin/lbry
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
