# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="mkcue generates cue sheets from a CD's TOC"
HOMEPAGE="https://diplodocus.org/projects/audio/"
SRC_URI="https://michael.englehorn.com/sources/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"
DEPEND="
	>=sys-libs/glibc-2.17
	>=sys-devel/gcc-6.5.0-r1:*
"

RDEPEND=">=sys-libs/glibc-2.17"

#src_install() {
	# make install does not work because target directory does not exist
#	dobin mkcue
#	dodoc README
#}
