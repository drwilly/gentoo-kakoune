# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Modal editor inspired by vim"
HOMEPAGE="http://kakoune.org/ https://github.com/mawww/kakoune"
LICENSE="Unlicense"

if [[ $PV == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mawww/kakoune"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/mawww/kakoune/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="debug static"

DEPEND="sys-libs/ncurses:0=[unicode]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i -e '/CXXFLAGS += -O3/d' src/Makefile || die "Failed to patch Makefile"
}

src_configure() {
	export version="v${PV}-gentoo"
	export debug=$(usex debug)
	export static=$(usex static)
}

src_install() {
	emake PREFIX="${D}"/usr docdir="${D}/usr/share/doc/${PF}" install

	rm "${D}/usr/share/man/man1/kak.1.gz" || die
	doman doc/kak.1
}
