name 'u2f'

unless windows?
  # https://github.com/Yubico/libu2f-host#building
  dependency 'pkg-config'
  dependency 'autoconf'
  dependency 'automake'
  dependency 'libtool'
  dependency 'help2man'
  dependency 'json-c'
  dependency 'hidapi'
  dependency 'gengetopt'

  default_version '1.1.10'

  source url: 'https://github.com/Yubico/libu2f-host/archive/libu2f-host-1.1.10.tar.gz'

  version '1.1.10' do
    source sha256: '45937c6c04349f865d9f047d3a68cc50ea24e9085d18ac2c7d31fa38eb749303'
  end

  relative_path "lib-u2fhost-lib-u2fhost-#{version}"

  build do
    env = with_standard_compiler_flags(with_embedded_path)

    command "./autogen.sh", env: env
    command "./configure --prefix '#{install_dir}/embedded'", env: env
    make 'check install', env: env
  end
end
