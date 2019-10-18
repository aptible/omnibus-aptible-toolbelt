name 'u2f'

unless windows?
  dependency 'autoconf'
  dependency 'automake'
  dependency 'libtool'
  dependency 'help2man'
  dependency 'gengetopt'

  default_version '1.1.10'

  source url: 'https://github.com/Yubico/libu2f-host/archive/libu2f-host-1.1.10.tar.gz'

  version '1.1.10' do
    source sha1: 'b324d98810f7d8602e9053ba947a5949863db3ea'
  end

  relative_path "lib-u2fhost-lib-u2fhost-#{version}"

  build do
    env = with_standard_compiler_flags(with_embedded_path)

    command "./autogen", env: env
    command "./configure --prefix '#{install_dir}/embedded'", env: env
    make 'check install', env: env
  end
end
