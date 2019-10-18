name 'gengetopt'

unless windows?
  default_version "2.23"

  source url: "https://ftp.gnu.org/gnu/gengetopt/gengetopt-#{version}.tar.xz"
end
