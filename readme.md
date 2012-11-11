### Setup repos for git deploys

This script configures repos to allow pushing from your local repo directly to a remote repo. It also adds a few lines to the `post-receive` hook for clearing cache and restarting the server.

This is aimed mostly for use with [Infinitas](http://infinitas-cms.org) or [CakePHP](http://cakephp.org) code bases but easy enough to modify for other apps.

### Setup

Clone or copy this repo to your server where you will be pushing to (where the `remote` repos are).

	git clone https://github.com/dogmatic69/GitDeploy.git

> Make sure the script is executable

If you have a number of sites it might be easier to add an alias to the script.

	echo 'alias cake_deploy="/path/to/deploy.sh"' >> ~/.bashrc

You will need to reload the `.bashrc` file before it can be used.

	. ~/.bashrc

### Usage

#### Basic

	$ cd /path/to/repo
	$ cake_deploy
	Adding: cd..
	Adding: git reset
	Adding: submodule update
	Run the following command on your local repo:

	git remote add production username@server:/path/to/repo

#### Hostname

With no params the username and host are automatically generated from `whoami` and `hostname`. This can be changed by passing the host you would rather use.

	$ cd /path/to/repo
	$ cake_deploy my_host
	Adding: cd..
	Adding: git reset
	Adding: submodule update
	Run the following command on your local repo:

	git remote add production my_host:/path/to/repo

#### Update

The script can be re-run on the same repo, it will attempt to check if the commands have already been added before adding them to the script.

	$ cd /path/to/repo
	$ cake_deploy
	Adding: cd..
	Adding: git reset
	Adding: submodule update
	Run the following command on your local repo:

	git remote add production username@server:/path/to/repo

	$ cd /path/to/repo
	$ cake_deploy
	No changes where made
	Run the following command on your local repo:

	git remote add production username@server:/path/to/repo

[Blog post](http://infinitas-cms.org/blog/general/simple-deployments-with-git)

Original idea taken from [this post](http://www.garygolden.me/blog/using-git-as-deployment-tool/) by Max Tsepkov
