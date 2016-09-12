INSTALL_DIR:=$(HOME)
SOURCE_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PLUGIN_DIR:=$(SOURCE_DIR)/vim/bundle
PLUGIN_SRC:=$(SOURCE_DIR)/

build: rc-files link-custom-dot-vim

rc-files:
	ln -si $(SOURCE_DIR)/vimrc $(INSTALL_DIR)/.vimrc
	ln -si $(SOURCE_DIR)/gvimrc $(INSTALL_DIR)/.gvimrc

link-custom-dot-vim:
	ln -si $(SOURCE_DIR)/vim/ $(INSTALL_DIR)/.vim

help:
	@echo ""
	@echo "	ARGUMENTS"
	@echo "		- INSTALL_DIR: default is $(HOME)"
	@echo "		- SOURCE_DIR: default is $(SOURCE_DIR)"
	@echo "	COMMANDS"
	@echo "	rc-files"
	@echo "		Symlink 'g/vimrc' files to your \$$INSTALL_DIR"
	@echo ""
