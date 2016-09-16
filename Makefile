# USER VARS ######################################
#
INSTALL_DIR:=$(HOME)
SOURCE_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VIMRCPATH:=$(INSTALL_DIR)/.vimrc
DOTVIMPATH:=$(INSTALL_DIR)/.vim

# not the vars you are looking for
#
.PHONY: install backup update clean restore .update-config .update-plugins .rc-backup .vim-backup .rc-clean .vim-clean .rc-restore .vim-restore
.DEFAULT_GOAL:=install
PLUGIN_DIR:=$(SOURCE_DIR)/vim/bundle
PLUGIN_SRC:=$(SOURCE_DIR)/


# GOALS #########################################
#
install: .update-plugins .deps/powerline-fonts/* $(INSTALL_DIR)/.vim $(INSTALL_DIR)/.vimrc
backup: .rc-files-backup .vim-files-backup
update: .update-config .update-plugins
clean: .rc-clean .vim-clean
restore: .rc-restore .vim-restore
.rc-files: .rc-backup $(INSTALL_DIR)/.vimrc
.dot-vim: .vim-backup $(INSTALL_DIR)/.vim


# create ########################################
#
$(INSTALL_DIR)/.vim:
	mkdir -p "$(INSTALL_DIR)/.vim/"

$(INSTALL_DIR)/.vimrc:
	ln -sbi "$(SOURCE_DIR)/vimrc" "$(INSTALL_DIR)/.vimrc"

$(INSTALL_DIR)/.vim/bundle:
	ln -sbi "$(SOURCE_DIR)/vim/*" "$(INSTALL_DIR)/.vim/"


# update ########################################
#
.update-config:
	git rebase origin/master

.update-plugins:
	git submodule update --init --recursive

deps/powerline-fonts/*:
	./deps/powerline-fonts/install.sh


# back-up #######################################
#
.rc-backup: .rc-clean
	$(shell [ -f "$(VIMRCPATH)" ] && mv "$(VIMRCPATH)" "$(VIMRCPATH)\.baklava")

.vim-backup: .vim-clean
	$(shell [ -f "$(DOTVIMPATH)" ] && mv "$(DOTVIMPATH)" "$(DOTVIMPATH)\.baklava")


# delete ########################################
#
.rc-clean:
	$(shell [ -L "$(VIMRCPATH)" ] && rm "$(VIMRCPATH)")

.vim-clean:
	$(shell [ -L "$(DOTVIMPATH)" ] && rm "$(DOTVIMPATH)")


# restore #######################################
#
.rc-restore: .rc-clean
	[ -f "$(VIMRCPATH)\.baklava" ] && mv "$(VIMRCPATH)\.baklava" "$(VIMRCPATH)"

.vim-restore: .vim-clean
	[ -f "$(DOTVIMPATH)\.baklava" ] && mv "$(DOTVIMPATH)\.baklava" "$(DOTVIMPATH)"


help:
	@echo "      _                  _     _     _                    __   __  ___   __  __ "
	@echo "     | |  _ __    __ _  | |_  | |_  | |_    ___  __ __ __ \ \ / / |_ _| |  \/  |"
	@echo "     |_| | '  \  / _\` | |  _| |  _| | ' \  / -_) \ V  V /  \ V /   | |  | |\/| |"
	@echo "     (_) |_|_|_| \__,_|  \__|  \__| |_||_| \___|  \_/\_/    \_/   |___| |_|  |_|"
	@echo ""
	@echo "COMMANDS"
	@echo " - install:     The default goal. Performs a backup (see below) and installs."
	@echo " - backup:      Moves any existing .vim/ or .vimrc to \$$INSTALL_DIR with a baklava extension. Symlinks are simply removed."
	@echo " - update:      Remote dotvimrc repo is rebased and submodules are updated."
	@echo " - clean:       This will only ever remove conflicting symlinks in \$$INSTALL_DIR and will never actually remove any real state."
	@echo " - restore:     Removes project symlinks and restores any backed-up config files."
	@echo ""
	@echo "ARGUMENTS"
	@echo " - INSTALL_DIR: default is $(HOME)"
	@echo " - SOURCE_DIR:  default is $(SOURCE_DIR)"
	@echo ""
