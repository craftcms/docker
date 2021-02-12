readonly local version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;")
readonly local system_arch=$(uname -p)

# determine the arch
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

echo "export BLACKFIRE_URL=https://blackfire.io/api/v1/releases/probe/php/linux/$arch_sys/$version" >> /etc/profile

readonly local ext_dir=$(find /usr/local/lib/php/extensions/ -name "no-debug-non-zts-*")
readonly local so_path="${ext_dir}/blackfire.so"
readonly local ext_string="extension=${so_path}"

# move the .so file into the
mv /tmp/blackfire/*.so $so_path

# load the extension in the ini file
echo $ext_string > /usr/local/etc/php/conf.d/ext-blackfire.ini
