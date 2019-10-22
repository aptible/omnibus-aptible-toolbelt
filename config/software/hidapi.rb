name 'hidapi'

unless windows?
  dependency 'linusb'
  dependency 'libudev'

  # https://github.com/signal11/hidapi
  # export STAGING=$HOME/out
  # export HOST=arm-linux

  # PKG_CONFIG_DIR= \
	# PKG_CONFIG_LIBDIR=$STAGING/lib/pkgconfig:$STAGING/share/pkgconfig \
	# PKG_CONFIG_SYSROOT_DIR=$STAGING \
	# ./configure --host=$HOST --prefix=$STAGING
end
