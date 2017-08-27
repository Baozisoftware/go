#!/usr/bin/env bash

V=`cat VERSION`
G=$V.linux.amd64
mkdir ../releases
mkdir ../tmp
cd src
C=`pwd`
chmod +x bootstrap.bash
export GOROOT_BOOTSTRAP=/home/travis/.gimme/versions/$G
export CGO_ENABLED=0

MAKE()
{
    export GOOS=$GOOS
    export GOARCH=$GOARCH
    ./bootstrap.bash
    B=../../go-$GOOS-$GOARCH-bootstrap
    N=$V.$GOOS-$GOARCH
    rm $B/automake.sh
    rm $B/.travis.yml
    if [ "$GOOS" = "windows" ]; then
        rm $B/bin/go
        rm $B/bin/gofmt
	fi
	T=$B.tbz
	if [ -e $T ] && [ -d $B ]; then
        Z=$N.zip
        D=../../tmp/go
        mkdir $D
        mv $B/* $D/
        cd ../../tmp
        zip -q -9 -r ../releases/$Z go/*
        cd $C
        rm -rf $D
        rm -rf $B
        rm $T
    fi
}

DONE()
{
    rm -rf ../../tmp
	echo All done.
	exit 0
}

#386:3
GOARCH=386

GOOS=darwin
MAKE
GOOS=linux
MAKE
GOOS=windows
MAKE

#amd64:3
GOARCH=amd64

GOOS=darwin
MAKE
GOOS=linux
MAKE
GOOS=windows
MAKE

#arm:1
GOARCH=arm

GOOS=linux
MAKE

#arm64:1
GOARCH=arm64

GOOS=linux
MAKE

#mips:1
GOARCH=mips

GOOS=linux
MAKE

#mipsle:1
GOARCH=mipsle

GOOS=linux
MAKE

#mips64:1
GOARCH=mips64

GOOS=linux
MAKE

#mips64le:1
GOARCH=mips64le

GOOS=linux
MAKE

DONE