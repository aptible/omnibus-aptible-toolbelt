Build on Windows
================

Download and Install
--------------------

Omnibus Toolchain (this is more or less what the Omnibus Cookbook does):

```
https://packages.chef.io/files/stable/omnibus-toolchain/1.1.46/windows/2012r2/omnibus-toolchain-1.1.46-1-x64.msi
```

Git (to clone the repo and for Omnibus caching):

```
https://git-scm.com/download/win
```

7Zip (to unpack ZIP source archives):

```
http://www.7-zip.org/download.html
```

Wix (to build MSI packages):

```
https://wix.codeplex.com/releases/view/624906
```

Windows SDK (to build APPX packages and sign packages), only choose to install
MSI tools and the SDK:

```
https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk
```

Visual Studio Community Edition 2017, install the "Desktop Development with
C++" and Windows 8.1 SDK components.

Preparation
-----------

### One-time things ###

Create tmp in `C:\opscode\omnibus-toolchain\embedded\bin` (yes, *in* `bin`). If
you don't do that the Omnibus build will emit warnings and eventually fail with
an obscure "too many arguments" error.

Configure `git`. If you don't do that, git caching won't work:

```
git config --global user.email "thomas@orozco.fr"
git config --global user.name "Thomas Orozco"
```

Import the code-signing certificate (it's in 1Password under `Microsoft
Authenticode Signing Key`). To do so, open the p12 file, select import in the
`Local Machine`, and provide the p12 password (found in 1Password as well). Use
the certificate manager to confirm the certificate was properly imported.

If you install a new certificate, you will need to update the thumbprint in
config/projects/aptible-toolbelt.rb

### Every time ###

Use an **administrator prompt**, and set up the environment:

```
SET PATH=C:\opscode\omnibus-toolchain\embedded\bin;%PATH%
SET PATH=C:\opscode\omnibus-toolchain\embedded\bin\usr\bin;%PATH%
SET PATH=C:\opscode\omnibus-toolchain\embedded\bin\mingw64\bin;%PATH%
SET PATH=C:\Program Files\7-Zip;%PATH%
SET PATH=C:\Program Files (x86)\WiX Toolset v3.10\bin;%PATH%
SET PATH=C:\Program Files (x86)\Windows Kits\10\bin\x64;%PATH%
SET SSL_CERT_DIR=C:\opscode\omnibus-toolchain\embedded\ssl\certs
SET SSL_CERT_FILE=C:\opscode\omnibus-toolchain\embedded\ssl\certs\cacert.pem
SET BUNDLE_GEMFILE=Gemfile.windows
```

Then, **if you're installing Omnibus and its dependencies:**

```
SET CC=x86_64-w64-mingw32-gcc
bundle install
```

Otherwise, if you're actually building the package:

```
set CC=
bundle exec omnibus build aptible-toolbelt
```
