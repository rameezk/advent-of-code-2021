SUBDIRS = $(shell ls -d */)

build-all:
	for dir in $(SUBDIRS) ; do make -C $$dir build ; done

clean-all:
	for dir in $(SUBDIRS) ; do make -C $$dir clean ; done

generate:
	cookiecutter __template__
