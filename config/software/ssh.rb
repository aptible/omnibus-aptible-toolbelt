name 'ssh'

dependency 'zlib'
dependency 'openssl'

license 'BSD'
license_file 'LICENCE'

if windows?
  default_version '0.0.6.0'

  source url: 'https://github.com/PowerShell/Win32-OpenSSH/releases/download/' \
              "v#{version}/OpenSSH-Win64.zip"

  version '0.0.6.0' do
    source sha1: 'cf5cbab5154145ff29626a57cfa39c2aba5d308f'
  end

  relative_path 'OpenSSH-Win64'
elsif mac_os_x?
  default_version '7.3p1'

  source path: '/Users/ec2-user/toolbelt/ssh-files'

  version '7.3p1' do
    source sha1: 'bfade84283fcba885e2084343ab19a08c7d123a5'
  end

  relative_path "openssh-#{version}"
else
  default_version '7.3p1'

  source url: 'http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/' \
    "openssh-#{version}.tar.gz"

  version '7.3p1' do
    source sha1: 'bfade84283fcba885e2084343ab19a08c7d123a5'
  end

  relative_path "openssh-#{version}"
end

build do
  unless windows? || mac_os_x?
    env = with_standard_compiler_flags(with_embedded_path)
    configure " --prefix=#{install_dir}/embedded", env: env
  end

  %w(ssh-keygen ssh).each do |binary|
    if windows?
      copy "#{project_dir}/#{binary}.exe",
           "#{install_dir}/embedded/bin/#{binary}.exe"
    elsif mac_os_x?
      copy "#{project_dir}/#{binary}",
           "#{install_dir}/embedded/bin/#{binary}"
    else
      make binary, env: env
      command "install -m 0755 #{binary} #{install_dir}/embedded/bin/#{binary}",
              env: env
    end
  end
end
