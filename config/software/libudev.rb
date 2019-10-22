name 'linudev'

unless windows?
  # https://github.com/signal11/hidapi
  # ./configure --disable-gudev --disable-introspection --disable-hwdb \
  # 		 --host=$HOST --prefix=$STAGING
  # make
  # make install
end
