# How to set up EC2 VM for build

## Setup

- Go to development AWS account
- Create a dedicated host for mac1.metal
- Launch an instance within that dedicated host
- Select Mac OSX Catalina AMI
- Add SSH security group to Inbound rules

## GUI Access

We need to run omnibus from the GUI because code signing requires us to type a
password into a prompt.

Run the following command to install and start VNC (macOS screen sharing SSH) from the Mac instance

```
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
```

Run the following command to set a password for ec2-user:

```
sudo /usr/bin/dscl . -passwd /Users/ec2-user
```

Create an SSH tunnel to the VNC port. In the following command, replace keypair_file with your SSH key path and 192.0.2.0 with your instance's IP address or DNS name.

```
ssh -i keypair_file -L 5900:localhost:5900 ec2-user@192.0.2.0
```

Note: The SSH session should be running while you're in the remote session.

Using a VNC client, connect to localhost:5900.

## Copy production signing cert and key

```
cp key.p12 ./omnibus-aptible-toolbelt/signing
cp cert.cer ./omnibus-aptible-toolbelt/signing
```

Be sure to remove your keys locally after they have been moved to the VM.

## Copy repo into VM

```
scp -r ./omnibus-aptible-toolbelt/ ec2-user@192.0.2.0:/Users/ec2-user/toolbelt
```

## Run omnibus

```
cd /Users/ec2-user/toolbelt
./buildscripts/osx-load-signing.sh
./buildscripts/native.sh
```

## Copy builds from host to your machine

```
scp ec2-user@192.0.2.0:/Users/ec2-user/toolbelt/pkg/* ~/Downloads
```

## Upload to S3

Upload the pkg files to the S3 bucket under `master/#{Travis Build Number}/pkg`. For example:

```
s3://omnibus-aptible-toolbelt/aptible/omnibus-aptible-toolbelt/master/194/pkg
```

Make sure the uploaded files are public (as in public object read enabled) either via the CLI or in the web console
