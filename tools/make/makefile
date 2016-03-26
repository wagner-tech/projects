# Generic makefile for mBuild build process

# defile default operations

NOP = @echo "No operation for target $@"
COMPILE = $(NOP)
COPY = $(NOP)
ZIP = zip -r $(project).zip $(project)
DEB = fakeroot dpkg-deb --build $(project)

#default parameters
project = default
SOURCES =
COPY_PRE =

# Load project specification
include make.pre

.SUFFIXES: .stamp .zip


#-----------------------------------------------------------------
# Hauptziele:
#
#               : ohne Parameter wird compiliert
# - zip         : packt ZIP file
# - deb         : packt Debian package
#
#-----------------------------------------------------------------

compile: $(COMPILE_TARGET)
	# compile ist fertig

zip: $(project).zip
	# ZIP file ready

deb: $(project).deb
	# Debian package ready

#-----------------------------------------------------------------
# compile steps
#-----------------------------------------------------------------
compile.stamp: $(SOURCES)
	$(COMPILE)
	@touch compile.stamp

#-----------------------------------------------------------------
# pack steps
#-----------------------------------------------------------------

copy.stamp: $(COPY_PRE)
	$(COPY) $(project)
	@touch copy.stamp

control.stamp: $(project).control
	mkdir -p $(project)/DEBIAN
	cp $(project).control $(project)/DEBIAN/control
	if [ -f $(project).postinst ]; then cp $(project).postinst $(project)/DEBIAN/postinst; fi
	@touch control.stamp

$(project).zip: copy.stamp $(project)
	$(ZIP)

$(project).deb: copy.stamp control.stamp
	$(DEB)
	cp $(project).deb $(project)_$(version)$(_arch).deb

#-----------------------------------------------------------------
# utilities
#-----------------------------------------------------------------
clean:
	-rm *.stamp 2>/dev/null
	if [ -e $(project).zip ]; then rm $(project).zip; fi
	if [ -e $(project) ]; then rm -rf $(project); fi

#-----------------------------------------------------------------
# Build-Regeln
#-----------------------------------------------------------------
%.pdf : %.tex $(SOURCES)
	pdflatex $<

