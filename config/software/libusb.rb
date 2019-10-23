name 'libusb'

unless windows?
  # https://github.com/signal11/hidapi#readme
  # ./configure --host=$HOST --prefix=$STAGING
  # make
  # make install
  default_version '1.0.23'

  source url: "https://github.com/libusb/libusb/archive/v#{version}.tar.gz"

  version '1.0.23' do
    source sha256: '02620708c4eea7e736240a623b0b156650c39bfa93a14bcfa5f3e05270313eba'
  end

  relative_path "libusb-#{version}"

  build do
    env = with_standard_compiler_flags(with_embedded_path)

    command "./configure --prefix '#{install_dir}/embedded'", env: env
    make env: env
    make 'install', env: env
  end
end
