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
    echo `ls $B`
    N=$V.$GOOS-$GOARCH
    rm $B/automake.sh
    rm $B/.travis.yml
    if [ "$GOOS" = "windows" ]; then
        rm $B/bin/go
        rm $B/bin/gofmt
    fi
    if [ -d $B ]; then
        Z=$N.zip
        D=../../tmp/go
        mkdir $D
        mv $B/* $D/
        cd ../../tmp
        zip -q -9 -r ../releases/$Z go/*
        cd $C
        rm -rf $D
        rm -rf $B
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

GOOS=windows
MAKE

DONE
