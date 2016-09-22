# USER VARS ######################################
#
INSTALL_DIR:=$(HOME)
SOURCE_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VIMRCPATH:=$(INSTALL_DIR)/.vimrc
DOTVIMPATH:=$(INSTALL_DIR)/.vim
LIB_CLANG_VERSION="3.9.0"
YOU_COMPLETE_ME_MF="Unix Makefiles"

# not the vars you are looking for
#
.PHONY: install backup update clean restore .update-config .update-plugins .rc-backup .vim-backup .rc-unlink .vim-unlink .rc-restore .vim-restore ycm_install ycm-clean ycm_configure
.DEFAULT_GOAL:=install
PLUGIN_DIR:=$(SOURCE_DIR)/vim/bundle
PLUGIN_SRC:=$(SOURCE_DIR)/


# GOALS #########################################
#
install: .update-plugins deps/powerline-fonts/* $(INSTALL_DIR)/.vim/bundle $(INSTALL_DIR)/.vimrc
backup: .rc-files-backup .vim-files-backup
update: .update-config .update-plugins
unlink: .vim-unlink .rc-unlink
clean: ycm-clean
restore: .rc-restore .vim-restore
ycm_clean_install: ycm_install ycm-clean
.rc-files: .rc-backup $(INSTALL_DIR)/.vimrc
.dot-vim: .vim-backup $(INSTALL_DIR)/.vim


# create ########################################
#
$(INSTALL_DIR)/.vim:
	mkdir -p "$(INSTALL_DIR)/.vim/"

$(INSTALL_DIR)/.vimrc:
	ln -si "$(SOURCE_DIR)/vimrc" "$(INSTALL_DIR)/.vimrc"

$(INSTALL_DIR)/.vim/bundle: $(INSTALL_DIR)/.vim
	ln -si "$(SOURCE_DIR)/vim/bundle" "$(INSTALL_DIR)/.vim/"


# YouCompleteMe #################################
#
$(INSTALL_DIR)/ycm_build:
	mkdir -p "$(INSTALL_DIR)/ycm_build"

$(INSTALL_DIR)/ycm_temp:
	mkdir -p "$(INSTALL_DIR)/ycm_temp"

/tmp/libclang.tar:
	$(shell curl -o "/tmp/libclang.tar.xz http://llvm.org/releases/${LIB_CLANG_VERSION}/clang+llvm-${LIB_CLANG_VERSION}-x86_64-apple-darwin.tar.xz" \
		&& gunzip -d "/tmp/libclang.tar.xz")

$(INSTALL_DIR)/ycm_temp/llvm_root_dir: $(INSTALL_DIR)/ycm_temp /tmp/libclang.tar
	tar -xopf /tmp/libclang.tar -C /tmp
	mv /tmp/clang* ~/ycm_temp/llvm_root_dir

ycm_configure: $(INSTALL_DIR)/ycm_temp/llvm_root_dir $(INSTALL_DIR)/ycm_build
	$(shell cd "${INSTALL_DIR}/ycm_build" \
	    && cmake -G ${YOU_COMPLETE_ME_MF} -DPATH_TO_LLVM_ROOT="${INSTALL_DIR}/ycm_temp/llvm_root_dir" . "${INSTALL_DIR}/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp")

ycm_install: ycm_configure
	$(shell cd ${INSTALL_DIR}/ycm_build && cmake --build . --target ycm_core --config Release)


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
.rc-backup: .rc-unlink
	$(shell [ -f "$(VIMRCPATH)" ] && mv "$(VIMRCPATH)" "$(VIMRCPATH)\.baklava")

.vim-backup: .vim-unlink
	$(shell [ -f "$(DOTVIMPATH)" ] && mv "$(DOTVIMPATH)" "$(DOTVIMPATH)\.baklava")


# clean #########################################
#
ycm-clean:
	rm -fr $(INSTALL_DIR)/ycm_temp
	rm -fr /tmp/clang*
	rm -fr $(INSTALL_DIR)/ycm_build


# unlink ########################################
#
.rc-unlink:
	$(shell [ -L "$(VIMRCPATH)" ] && rm "$(VIMRCPATH)")

.vim-unlink:
	$(shell [ -L "$(DOTVIMPATH)" ] && rm "$(DOTVIMPATH)")


# restore #######################################
#
.rc-restore: .rc-unlink
	$(shell [ -f "$(VIMRCPATH)\.baklava" ] && mv "$(VIMRCPATH)\.baklava" "$(VIMRCPATH)")

.vim-restore: .vim-unlink
	$(shell [ -f "$(DOTVIMPATH)\.baklava" ] && mv "$(DOTVIMPATH)\.baklava" "$(DOTVIMPATH)")


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
