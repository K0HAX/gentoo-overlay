# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_REMOVE_MODULES_LIST="FindLibObs"
inherit cmake

if [[ ${PV} == "9999" ]]; then
	inherit git-r3

	SRC_URI=""
	EGIT_REPO_URI="https://github.com/vector-im/riot-web.git"
	EGIT_REPO_URI="https://github.com/CatxFish/obs-v4l2sink.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/vector-im/riot-web/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	COMMIT="1ec3c8ada0e1040d867ce567f177be55cd278378"
	SRC_URI="https://github.com/CatxFish/obs-v4l2sink/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi

DESCRIPTION="obs studio output plugin for Video4Linux2 device"
HOMEPAGE="https://github.com/CatxFish/obs-v4l2sink"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=media-video/obs-studio-25.0.8-r1
		dev-qt/qtwidgets:5
		dev-qt/qtgui:5
		dev-qt/qtcore:5
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	sed -i -e '/include(external\/FindLibObs.cmake)/d' -e 's#../UI#UI#' CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DLIBOBS_INCLUDE_DIR="/usr/include/obs/"
	)
	cmake_src_configure
}
