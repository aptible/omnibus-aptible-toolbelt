name 'gengetopt'

unless windows?
  # https://www.gnu.org/software/gengetopt/gengetopt.html#Installation
  default_version '2.23'

  source url: "https://ftp.gnu.org/gnu/gengetopt/gengetopt-#{version}.tar.xz"

  version '2.23' do
    source sha256: 'b941aec9011864978dd7fdeb052b1943535824169d2aa2b0e7eae9ab807584ac'
  end

  relative_path "gengetopt-#{version}"

  build do
    env = with_standard_compiler_flags(with_embedded_path)

    command "./configure --prefix '#{install_dir}/embedded'", env: env
    make env: env
    make 'install', env: env
  end
end
