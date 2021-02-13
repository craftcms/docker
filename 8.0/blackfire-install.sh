readonly local version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;")
readonly local system_arch=$(uname -p)
arch_sys="amd64"
case $system_arch in
    "aarch64")
        arch_sys="arm64"
    ;;
    "arm64")
        arch_sys="arm64"
    ;;
    "x86_64")
        arch_sys="amd64"
    ;;
esac

readonly local BLACKFIRE_URL=https://blackfire.io/api/v1/releases/probe/php/linux/$arch_sys/$version
readonly local ext_dir=$(find /usr/local/lib/php/extensions/ -name "no-debug-non-zts-*")
readonly local so_path="${ext_dir}/blackfire.so"
readonly local ext_ini_string="extension=${so_path}"

# download the probe
curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s $BLACKFIRE_URL

# create the temp dir
mkdir -p /tmp/blackfire

# untar the download
tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire

# move the .so file into the
cp /tmp/blackfire/blackfire-*.so $so_path

# load the extension in the ini file
echo $ext_ini_string > /tmp/ext-blackfire.ini
