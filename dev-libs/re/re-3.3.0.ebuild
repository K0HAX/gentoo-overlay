# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Baresip is a generic library for real-time communications with async IO support"
HOMEPAGE="https://github.com/baresip/re"

LICENSE="BSD"
SLOT="0"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/baresip/re.git"
	KEYWORDS="~adm64 ~x86"
else
	SRC_URI="https://github.com/baresip/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

inherit cmake

IUSE=""

REQUIRED_USE=""

DEPEND=""

RDEPEND="${DEPEND}"

src_configure() {
	cmake_src_configure
}

