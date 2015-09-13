#!/bin/sh

# git-tagflow make-less installer for *nix systems, by Rick Osborne
# Based on the git-tagflow core Makefile:
# http://github.com/nvie/gitflow/blob/master/Makefile

# Licensed under the same restrictions as git-tagflow:
# http://github.com/nvie/gitflow/blob/develop/LICENSE

# Does this need to be smarter for each host OS?
if [ -z "$INSTALL_PREFIX" ] ; then
	INSTALL_PREFIX="/usr/local/bin"
fi

if [ -z "$REPO_NAME" ] ; then
	REPO_NAME="gitflow"
fi

if [ -z "$REPO_HOME" ] ; then
	REPO_HOME="http://github.com/nvie/gitflow.git"
fi

EXEC_FILES="git-tagflow"
SCRIPT_FILES="git-tagflow-init git-tagflow-feature git-tagflow-hotfix git-tagflow-release git-tagflow-support git-tagflow-version git-tagflowcommon git-tagflow-shFlags"
SUBMODULE_FILE="git-tagflow-shFlags"

echo "### gitflow no-make installer ###"

case "$1" in
	uninstall)
		echo "Uninstalling git-tagflow from $INSTALL_PREFIX"
		if [ -d "$INSTALL_PREFIX" ] ; then
			for script_file in $SCRIPT_FILES $EXEC_FILES ; do
				echo "rm -vf $INSTALL_PREFIX/$script_file"
				rm -vf "$INSTALL_PREFIX/$script_file"
			done
		else
			echo "The '$INSTALL_PREFIX' directory was not found."
			echo "Do you need to set INSTALL_PREFIX ?"
		fi
		exit
		;;
	help)
		echo "Usage: [environment] git-tagflowinstaller.sh [install|uninstall]"
		echo "Environment:"
		echo "   INSTALL_PREFIX=$INSTALL_PREFIX"
		echo "   REPO_HOME=$REPO_HOME"
		echo "   REPO_NAME=$REPO_NAME"
		exit
		;;
	*)
		echo "Installing git-tagflow to $INSTALL_PREFIX"
		if [[ -d "$REPO_NAME" && -d "$REPO_NAME/.git" ]] ; then
			echo "Using existing repo: $REPO_NAME"
		else
			echo "Cloning repo from GitHub to $REPO_NAME"
			git clone "$REPO_HOME" "$REPO_NAME"
		fi
		if [ -f "$REPO_NAME/$SUBMODULE_FILE" ] ; then
			echo "Submodules look up to date"
		else
			echo "Updating submodules"
			lastcwd=$PWD
			cd "$REPO_NAME"
			git submodule init
			git submodule update
			cd "$lastcwd"
		fi
		install -v -d -m 0755 "$INSTALL_PREFIX"
		for exec_file in $EXEC_FILES ; do
			install -v -m 0755 "$REPO_NAME/$exec_file" "$INSTALL_PREFIX"
		done
		for script_file in $SCRIPT_FILES ; do
			install -v -m 0644 "$REPO_NAME/$script_file" "$INSTALL_PREFIX"
		done
		exit
		;;
esac
