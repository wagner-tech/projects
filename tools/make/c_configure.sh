#!/bin/bash

# util routines for a C/C++ - build

function check_arch {
	case $1 in
	armel) ;;
	i386) ;;
	*)	echo "unknown architecture $1"
		exit 1
	esac
}

function install_cpp_make {
# $1: dir to install
	src=$(pwd);
	pushd $1
	if [ -f makefile ]; then rm makefile; fi
	if [ -f make.post ]; then rm make.post; fi
	ln -s $cwd/Make/cpp.make makefile
	echo "SOURCE = \\" > make.pre
	for file in $(ls *.cpp)
	do
		echo "  $file \\" >> make.pre
	done
	echo >> make.pre
	if [ "$ARCH" = "armel" ]
	then
		echo "CXX = arm-linux-gnueabi-g++" >> make.pre
		echo "CC = arm-linux-gnueabi-g++" >> make.pre
		echo "CXXFLAGS += -D_ARMEL" >> make.pre
		echo 'export PATH := /opt/eldk-5.0/armv5te/sysroots/i686-oesdk-linux/usr/bin/armv5te-linux-gnueabi/:/opt/eldk-5.0/armv5te/sysroots/i686-oesdk-linux/bin/armv5te-linux-gnueabi/:$(PATH)' >> make.pre
	fi
	echo "CXXFLAGS += -std=c++0x -I$src/util" >> make.pre
	popd
}

function append_dependency {
# parameter:
# $1: main directory
# $2: dependency directory
# $3: dependency artefact

	src=$(pwd)
	echo "DEPS += $3" >> $1/make.pre
	echo "$3:" >> $1/make.post
	echo "	cd $src/$2 && make TARGET=$3" >> $1/make.post
	echo "" >> $1/make.post
}

function append_library {
# parameter:
# $1: main directory
# $2: dependency directory
# $3: dependency artefact

	src=$(pwd)
	echo "DEPS += $3" >> $1/make.pre
	echo "LDLIBS += $3" >> $1/make.pre
	echo "$3:" >> $1/make.post
	echo "	cd $src/$2 && make TARGET=$3" >> $1/make.post
	echo "	ln -sf $src/$2/$3 ." >> $1/make.post
	echo "" >> $1/make.post
}

