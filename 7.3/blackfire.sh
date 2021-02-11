#!/bin/sh
set -ex

# get the php version as a local variable
readonly local php_version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;")

# determine the arch
readonly local system_arch=$(uname -m)

# get the arch
arch="amd64"
case $system_arch in
    "arm64")
        arch="arm64"
    ;;
    "x86_64")
        arch="amd64"
    ;;
esac

# download the prob using the arch and version
curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s "https://blackfire.io/api/v1/releases/probe/php/linux/${arch}/${php_version}"

# make the temp dir
mkdir -p /tmp/blackfire

# open the probe into the temp dir
tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire

# move the .so file into the
mv /tmp/blackfire/*.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/blackfire.so

# load the extension in the ini file
echo 'extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/blackfire.so' > /usr/local/etc/php/conf.d/ext-blackfire.ini
