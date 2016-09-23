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
.PHONY: install backup update clean restore .update-config .update-plugins .rc-backup .vim-backup .rc-unlink .vim-unlink .rc-restore .vim-restore ycm-install ycm-clean ycm-configure
.DEFAULT_GOAL:=install
PLUGIN_DIR:=$(SOURCE_DIR)/vim/bundle
PLUGIN_SRC:=$(SOURCE_DIR)/


# GOALS #########################################
#
install: .update-plugins deps/powerline-fonts/* ycm-install $(INSTALL_DIR)/.vim/bundle $(INSTALL_DIR)/.vimrc
backup: .rc-files-backup .vim-files-backup
update: .update-config .update-plugins
unlink: .vim-unlink .rc-unlink
clean: ycm-clean
restore: .rc-restore .vim-restore
ycm-clean-install: ycm-install ycm-clean
.rc-files: .rc-backup $(INSTALL_DIR)/.vimrc
.dot-vim: .vim-backup $(INSTALL_DIR)/.vim


# create ########################################
#
$(INSTALL_DIR)/.vim:
	$(shell mkdir -p "$(INSTALL_DIR)/.vim/")

$(INSTALL_DIR)/.vimrc:
	$(shell ln -si "$(SOURCE_DIR)/vimrc" "$(INSTALL_DIR)/.vimrc")

$(INSTALL_DIR)/.vim/bundle: $(INSTALL_DIR)/.vim
	$(shell ln -si "$(SOURCE_DIR)/vim/bundle" "$(INSTALL_DIR)/.vim/")


# Airline #######################################
#
deps/powerline-fonts/*:
	./deps/powerline-fonts/install.sh


# YouCompleteMe #################################
#
/tmp/libclang.tar.xz:
	$(shell curl -o "/tmp/libclang.tar.xz" "http://llvm.org/releases/${LIB_CLANG_VERSION}/clang+llvm-${LIB_CLANG_VERSION}-x86_64-apple-darwin.tar.xz")

/tmp/libclang.tar: /tmp/libclang.tar.xz
	$(shell gunzip -fd "/tmp/libclang.tar.xz")

/tmp/clang+llvm-$(LIB_CLANG_VERSION)-x86_64-apple-darwin: /tmp/libclang.tar
	$(shell tar -xop -f "/tmp/libclang.tar" -C "/tmp")

deps/ycm/ycm-temp/llvm_root_dir: /tmp/clang+llvm-$(LIB_CLANG_VERSION)-x86_64-apple-darwin
	$(shell mv -f "/tmp/clang+*" "deps/ycm/ycm-temp/llvm_root_dir")

ycm-configure: deps/ycm/ycm-temp/llvm_root_dir
	$(shell cmake -G ${YOU_COMPLETE_ME_MF} -D"PATH_TO_LLVM_ROOT=deps/ycm/ycm-temp/llvm_root_dir" -B"deps/ycm/ycm-build/" -H"vim/bundle/YouCompleteMe/third_party/ycmd/cpp")

ycm-install: ycm-configure
	$(shell cmake --build "deps/ycm/ycm-build/" --target ycm_core --config Release)


# update ########################################
#
.update-config:
	$(shell git rebase origin/master)

.update-plugins:
	$(shell git submodule update --init --recursive)


# back-up #######################################
#
.rc-backup: .rc-unlink
	$(shell [ -f "$(VIMRCPATH)" ] && mv "$(VIMRCPATH)" "$(VIMRCPATH)\.baklava")

.vim-backup: .vim-unlink
	$(shell [ -f "$(DOTVIMPATH)" ] && mv "$(DOTVIMPATH)" "$(DOTVIMPATH)\.baklava")


# clean #########################################
#
ycm-clean:
	rm -fr deps/ycm/ycm-temp/*
	rm -fr /tmp/clang*
	rm -fr deps/ycm/ycm-build/*


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
	@echo " - unlink:      Remove conflicting symlinks in \$$INSTALL_DIR and will never actually remove any real state."
	@echo " - restore:     Removes project symlinks and restores any backed-up config files."
	@echo ""
	@echo "ARGUMENTS"
	@echo " - INSTALL_DIR: default is $(HOME)"
	@echo " - SOURCE_DIR:  default is $(SOURCE_DIR)"
	@echo ""
