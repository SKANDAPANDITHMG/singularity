#!/bin/sh -
set -e

topdir=$PWD
coredir=$topdir/core
buildtree=$coredir/buildtree

#
# Singularity core C portion (libsycore.a)
#
if [ -d "$buildtree" ]; then
	make -j `nproc` -C $buildtree
else
	cd $coredir
	./mconfig -b $buildtree
	make -j `nproc` -C $buildtree
	cd $topdir
fi

#
# Go portion
#
CGO_CPPFLAGS="$CGO_CPPFLAGS -I$buildtree -I$coredir -I$coredir/lib"
CGO_LDFLAGS="$CGO_LDFLAGS -L$buildtree/lib"
export CGO_CPPFLAGS CGO_LDFLAGS

go build -o singularity cmd/cli/cli.go