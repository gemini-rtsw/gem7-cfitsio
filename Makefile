# $Id$
#

include .applTop/config/CONFIG

APPLIC_DIR_TYPE = sys

include .applTop/config/RULES.Dirs

PROD     = $(notdir $(shell pwd))
TAR      = /usr/bin/tar
COMPRESS = gzip
DIST_SYS = $(word 1, $(filter-out /%, $(subst -, ,$(notdir $(APPLIC_IOCPATH)))))

release:
	$(RM) $(PROD).tar $(PROD).tar.Z $(PROD).tar.gz .xfile makeLog*
	find * \
	    \( -name bin -o -name lib -o -name config -o -name db -o -name epics \
		-o -name 'O.*' -o -name '*.dctsdr' -o -name '*.sdrSum' \
		-o -name '*%' -o -name '*~' -o -name '*.Z' -o -name '*.gz' \
		-o -name include -o -name Distfile -o -name data \
		-o -name CVS -o -name '.applTop' \
	    \) -prune -print > .xfile
#
# Because some systems still don't use the default colors.adl
# Also because 'applSetup' does not copy the local colors.adl
# or template.adl if the 'dl' directory exists
#	echo 'dl/colors.adl' >> .xfile
#	echo 'dl/template.adl' >> .xfile
#
	echo 'capfast/cad.rc' >> .xfile
	echo 'startup/local.vws' >> .xfile
	echo 'startup/resource.def' >> .xfile
	$(TAR) cvXf .xfile $(PROD).tar $(APPLIC_SUBDIR_FILE) *
	$(COMPRESS) $(PROD).tar
	$(RM) .xfile

gemini:
	@gmake;								       \
	gmake rdist;							       \
	rsh $(DIST_HOST) touch $(DIST_PATH)/$(notdir $(APPLIC_IOCPATH));       \
	rsh $(DIST_HOST) rm -f /export/gemini/$(DIST_SYS);                     \
	rsh $(DIST_HOST) chmod 775 $(DIST_PATH); 			       \
	rsh $(DIST_HOST) ln -s $(DIST_PATH) /export/gemini/$(DIST_SYS);        \
	rsh $(DIST_HOST) rm -f /export/gemini/$(DIST_SYS)/epics;               \
	rsh $(DIST_HOST) ln -s /export/gemini/external/epics /export/gemini/$(DIST_SYS)/epics;
