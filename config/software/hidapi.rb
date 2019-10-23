name 'hidapi'

unless windows?
  # https://github.com/signal11/hidapi#readme
  dependency 'libusb'
  dependency 'udev'

  default_version '0.13.1'

  source url: "https://s3.amazonaws.com/json-c_releases/releases/json-c-#{version}.tar.gz"

  version '0.13.1' do
    source sha256: 'b87e608d4d3f7bfdd36ef78d56d53c74e66ab278d318b71e6002a369d36f4873'
  end

  relative_path "json-c-#{version}"

  build do
    staging = "#{install_dir}/embedded"
    env = with_standard_compiler_flags(with_embedded_path \
      STAGING: staging,
      PKG_CONFIG_DIR: '',
      PKG_CONFIG_LIBDIR: "#{staging}/lib/pkgconfig:$STAGING/share/pkgconfig",
      PKG_CONFIG_SYSROOT_DIR: staging
    )

    command "./configure --prefix '#{staging}'", env: env
  end
end
