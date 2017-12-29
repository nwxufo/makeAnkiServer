PRODUCT=AnkiServer

SHELL := /bin/bash
PREFIX=/srv/test
#DATA_PATCH=${PREFIX}/${PRODUCT}.data

USER=fenghuo #system user which to run as systemd or supervisor.
GROUP=fenghuo

export PRODUCT
export SHELL
export USER
export GROUP
export PREFIX
export DATA_PATCH
#database dir
#Warning: Must corresponding with file production.ini 's parameter
#	[app:sync_app]

all:
	echo "make install" for delopy AnkiService"
	echo "make uninstall" for clear AnkiService delopyment file"
	echo "README FIRST! README FIRST! README FIRST!"
	echo "modify the var listed in the Maekfile before install"

install : help-info
	echo "install ${PRODUCT} successful"
	echo "if you run on Debian: then run: `make fix-bugs`"
	echo "now run --make create-account--- to creat a AnkiServer User."
#	$(MAKE) -f Makefile.uwsgi

fix-bugs:
#fix Debian 8/9 's bug : not found anki module
	echo "${PREFIX}/${PRODUCT}.env/anki-bundled" >>${PREFIX}/${PRODUCT}.env/lib/python2.7/site-packages/anki-module.pth

creat-account:
	( \
    source ${PREFIX}/${PRODUCT}.env/bin/activate;\
	read  -p "Add AnkiServer Account UserName:" ACCOUNT;\
	cd $DATA_PATCH;\
	ankiserverctl.py adduser $$ACCOUNT;\
	)

config-AnkiServer:
	$(MAKE) -f Makefile.AnkiServer

config-systemd: config-AnkiServer
	rm -rf ${PRODUCT}.systemd.service
	$(MAKE) -f Makefile.systemd

config-nginx: config-systemd
	sudo rm -rf /etc/nginx/sites-available/AnkiServer.nginx.ln
	sudo rm -rf /etc/nginx/sites-enabled/AnkiServer.nginx.ln
	$(MAKE) -f Makefile.nginx
#sudo systemctl enable ${PRODUCT}.service

help-info: config-nginx 
	echo "sudo systemctl <stop|start|restart|status> AnkiServer"

uninstall:
	$(MAKE) -f Makefile.nginx uninstall
	$(MAKE) -f Makefile.systemd uninstall
