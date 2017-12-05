# OMC - Opsworks' Missing Console

Useful commands for dealing with AWS and opsworks across multiple IAM accounts.


## Installation

```
gem install omc
```

### Config

omc supports a configuration file to specify your account rather than providing
it with the `-a` flag. Formatted like so:

```toml
account = "zerg"
```

It can be located at `~/.omcrc`, `~/.config/omcrc`, or local to where you're running
your command `.omcrc`


### AWS Cred Vault

omc works off of [aws_cred_vault](http://www.github.com/cbrunsdon/aws_cred_vault) and requires an ~/.aws_cred_vault file to exist. This file should be populated with your different IAM accounts and users.

Below is an example of a valid ~/.aws_cred_vault

```toml
[accounts.protoss.fenix]
access_key = "fenix"
secret = "zealot!"

[accounts.protoss.tassadar]
access_key = "tassadar"
secret = "lightning!"

[accounts.terran.raynor]
access_key = "raynor"
secret = "abcd1234"
```

## Usage

```
omc help
```

Accepted ssh options:
```
-R 3000:localhost:3001 # Forwards port 3000 on the remote host to port 3001 on the localhost
-A                     # Forward agent
```

Please the the ssh help for more detail.
