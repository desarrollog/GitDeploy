#!/usr/bin/env bash

# Variables
postReceive="hooks/post-receive"
hook=".git/"$postReceive;
production=`pwd`;
host="`whoami`@`hostname`";
adjusted=0;

if [ $1 ];
then
	if [ $1 == "help" ];
	then
		echo "Setup a remote repo to allow pushing updated directly";
		echo;
		echo "This will configure the repo to receive pushes and setup a post-receive hook";
		echo "Usage:";
		echo "    No params:";
		echo "    $0";
		echo;
		echo "    Pass host:";
		echo "    $0 host";
		echo;
		echo "Passing the host will generate the correct line to run on your local repo to create the git remote link";
		exit;
	fi
	host=$1;
fi

if [ ! -d .git ];
then
	echo "Not a git repository";
	exit;
fi

git config receive.denyCurrentBranch ignore

if [ ! -f $hook ];
then
	touch $hook;
	sudo chmod u+x $hook;
	echo "#!/bin/sh" > $hook;
	adjusted=1;
fi

CD=`cat $hook | grep -- "cd.."`;
if [ ! "$CD" ];
then
	echo "Adding: cd..";
	echo "cd.." >> $hook;
	adjusted=1;
fi

RESET=`cat $hook | grep -- "reset --hard"`;
if [ ! "$RESET" ];
then
	echo "Adding: git reset";
	echo "env -i git reset --hard" >> $hook;
	adjusted=1;
fi

UPDATE=`cat $hook | grep -- "submodule update"`;
if [ ! "$UPDATE" ];
then
	echo "Adding: submodule update";
	echo "env -i git submodule update --recursive" >> $hook;
	adjusted=1;
fi

if [ -d Core/Data ];
then
	echo "Adding: Infinitas cache clear";
	echo "Console/cake data.clear_cache" >> $hook;
	adjusted=1;
fi

if [ -f index.php ];
then
	echo "Adding: Server reset";
	echo "sudo service php-fpm restart" >> $hook;
	adjusted=1;
fi

if [ $adjusted == 0 ];
then
	echo "No changes where made";
fi

echo "Run the following command on your local repo:";
echo;
echo "git remote add production $host:$production";
