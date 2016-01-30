# Makefile for mdns-repeater

ZIP_NAME = mdns-repeater-$(VERSION)

ZIP_FILES = mdns-repeater \
			README.txt \
			LICENSE.txt

VERSION=$(shell git rev-parse --short HEAD)

CFLAGS=-Wall -pedantic

ifdef DEBUG
	CFLAGS+= -g
else
	CFLAGS+= -Os
	LDFLAGS+= -s
endif

CFLAGS+= -DVERSION="\"${VERSION}\""

.PHONY: all clean

all: mdns-repeater

mdns-repeater: mdns-repeater.o

.PHONY: zip
zip: TMPDIR := $(shell mktemp -d)
zip: mdns-repeater
	mkdir $(TMPDIR)/$(ZIP_NAME)
	cp $(ZIP_FILES) $(TMPDIR)/$(ZIP_NAME)
	-$(RM) $(CURDIR)/$(ZIP_NAME).zip
	cd $(TMPDIR) && zip -r $(CURDIR)/$(ZIP_NAME).zip $(ZIP_NAME)
	-$(RM) -rf $(TMPDIR)

clean:
	-$(RM) *.o
	-$(RM) _hgversion
	-$(RM) mdns-repeater
	-$(RM) mdns-repeater-*.zip

.PHONY: test
test: mdns-repeater
	sudo ./mdns-repeater -f wlp3s0 docker0
