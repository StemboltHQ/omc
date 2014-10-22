# Omc - Opsworks Missing Console

Useful commands for dealing with AWS and opsworks across multiple IAM accounts.


## Installation

```
gem install omc
```

### Aws Cred Vault

omc works off of [aws_cred_vault](www.github.com/cbrunsdon/aws_cred_vault) and requires a ~/.aws_cred_vault file to exist. This file should be populated with your different IAM accounts and users.

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
