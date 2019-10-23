name 'json-c'

unless windows?
  # https://github.com/json-c/json-c/wiki#overview
  default_version '0.13.1'

  source url: "https://s3.amazonaws.com/json-c_releases/releases/json-c-#{version}.tar.gz"

  version '0.13.1' do
    source sha256: 'b87e608d4d3f7bfdd36ef78d56d53c74e66ab278d318b71e6002a369d36f4873'
  end

  relative_path "json-c-#{version}"

  build do
    env = with_standard_compiler_flags(with_embedded_path)

    command "./configure --prefix '#{install_dir}/embedded'", env: env
    make env: env
    make 'check install', env: env
  end
end
