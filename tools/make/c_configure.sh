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
	if [ -L makefile ]; then rm makefile; fi
	if [ -f make.post ]; then rm make.post; fi
	ln -s $cwd/projects/tools/make/cpp.make makefile
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
	elif [ "$ARCH" = "amd64" ]
	then
		echo "CXXFLAGS += -m64 -std=c++0x -fPIC" >> make.pre
	else
		echo "CXXFLAGS += -std=c++0x" >> make.pre
	fi
	popd
}

function append_dependency {
# adds another drectory, where a c++ compile is performed
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

function add_include {
# adds a include directory
# parameter:
# $1: main directory
# $2: include dir

	src=$(pwd)
	echo "CXXFLAGS += -I$src/$2" >> $1/make.pre
}

function append_library {
# same as append_dependency. In addition a include statement + a link to the library is added to "main directory"
# parameter:
# $1: main directory
# $2: dependency directory
# $3: dependency artefact

	src=$(pwd)
	echo "DEPS += $3" >> $1/make.pre
	echo "LDLIBS += $3" >> $1/make.pre
	echo "CXXFLAGS += -I$src/$2" >> $1/make.pre
	echo "$3:" >> $1/make.post
	echo "	cd $src/$2 && make TARGET=$3" >> $1/make.post
	echo "	ln -sf $src/$2/$3 ." >> $1/make.post
	echo "" >> $1/make.post
}

