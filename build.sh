#!/usr/bin/env bash
set -e 

PROJECT="atools"
PROJECT_USER="$USER"
PROJECT_DIR="/opt/$PROJECT"
PROJECT_CACHE_DIR="/var/cache/omnibus"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
rvm use ruby-2.2.2

echo "> PATH=$PATH"
echo "> WHOAMI=`whoami`"
if [ `uname` == "Darwin" ]; then 
	SUDO="sudo"
else
	SUDO=""
	echo "> SUDO NO"
	echo "> USING RVM"
	rvm use ruby-2.2.2
fi

if [ $(basename `pwd`) != "omnibus-$PROJECT" ]; then
	echo "> cd omnibus-$PROJECT"
	cd omnibus-$PROJECT
fi

echo "> $SUDO gem install bundle --no-rdoc --no-ri"
$SUDO gem install bundle --no-rdoc --no-ri
echo "> $SUDO bundle install --binstubs"
$SUDO bundle install --binstubs

old_hash="d7f7dd7e3ede3e323fc0e09381f16caf"
new_hash="380df856e8f789c1af97d0da9a243769"
echo ">  find . -name cacerts*  -type f  -exec sed -i -e 's/d7f7dd7e3ede3e323fc0e09381f16caf/380df856e8f789c1af97d0da9a243769/g' {} \;"
sudo find / -name cacert*  -type f  -exec sed -i -e 's/d7f7dd7e3ede3e323fc0e09381f16caf/380df856e8f789c1af97d0da9a243769/g' {} \;

echo "Create prvoject dir in $PROJECT_DIR and cache dir in $PROJECT_CACHE_DIR"
sudo mkdir -p $PROJECT_DIR
sudo mkdir -p $PROJECT_CACHE_DIR
sudo chown $PROJECT_USER $PROJECT_CACHE_DIR
sudo chown $PROJECT_USER $PROJECT_DIR
echo "> omnibus build $PROJECT"
$SUDO  omnibus build $PROJECT 