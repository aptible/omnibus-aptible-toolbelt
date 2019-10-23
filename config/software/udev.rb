name 'udev'

unless windows?
  # https://github.com/signal11/hidapi#readme
  # https://git.kernel.org/pub/scm/linux/hotplug/udev.git
  default_version '182'

  source url: "https://git.kernel.org/pub/scm/linux/hotplug/udev.git/snapshot/udev-#{version}.tar.gz"

  version '182' do
    source sha256: 'ab462c046189db86edb325c5c1976e17a33a0d6bef40a6dbbec8c07ceb2a40ff'
  end

  relative_path "udev-#{version}"

  build do
    env = with_standard_compiler_flags(with_embedded_path)

    command './autogen.sh'
    command './configure --disable-gudev --disable-introspection ' \
      "--disable-hwdb --prefix '#{install_dir}/embedded'", env: env
    make env: env
    make 'install', env: env
  end
end
