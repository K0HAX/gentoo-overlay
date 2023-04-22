# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Baresip is a portable and modular SIP User-Agent with audio and video support."
HOMEPAGE="http://creytiv.com/baresip.html"

LICENSE="BSD"
SLOT="0"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/baresip/baresip.git"
	KEYWORDS="~adm64 ~x86"
else
	SRC_URI="https://github.com/baresip/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

inherit cmake

IUSE="alsa amr avahi cairo codec2 +cons evdev ffmpeg +g711 g722 g7221 g726 gsm gstaudio gstvideo gtk h265 ilbc isac jack +l16 libnotify mpa mpg123 mqtt openssl opus opus-ms oss plc portaudio pulseaudio rtcp-summary sdl2 sndfile speex srtp +stdio syslog v4l2 x11 vpx"

REQUIRED_USE="
	libnotify? ( gtk )
	"

DEPEND="
	dev-libs/re
	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	avahi? ( net-dns/avahi )
	ffmpeg? ( media-video/ffmpeg )
	cairo? ( x11-libs/cairo )
	codec2? ( media-libs/codec2 )
	evdev? ( dev-libs/libevdev )
	g722? ( media-libs/spandsp )
	g7221? ( media-libs/libg7221 )
	gsm? ( media-sound/gsm )
	gstaudio? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0
	)
	gstvideo? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0
	)
	gtk? ( x11-libs/gtk+:2 )
	h265? ( media-video/ffmpeg )
	ilbc? ( media-libs/libilbc )
	jack? ( virtual/jack )
	libnotify? ( x11-libs/libnotify )
	mpa? (
		media-sound/twolame
		media-sound/mpg123
		media-libs/speexdsp
	)
	mpg123? ( media-sound/mpg123 )
	mqtt? ( app-misc/mosquitto )
	openssl? ( dev-libs/openssl:0= )
	opus? ( media-libs/opus )
	opus-ms? ( media-libs/opus )
	oss? ( media-libs/alsa-oss )
	plc? ( media-libs/spandsp )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sdl2? ( media-libs/libsdl2 )
	sndfile? ( media-libs/libsndfile )
	speex? ( media-libs/speex )
	srtp? ( net-libs/libsrtp )
	x11? ( x11-libs/libX11 )
	vpx? ( media-libs/libvpx )
	"

RDEPEND="${DEPEND}"

#usetf() {
#	usex "$1" "yes"
#}

src_configure() {
	cmake_src_configure
}

