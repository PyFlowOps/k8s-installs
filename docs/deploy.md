# PyFlowOps Deployments

## Local

This is the deploy directory for all deployments pertaining to the PyFlowOps ecosystem. The
local environment simulates the production environment _(Kubernetes)_ with the ability to
develop locally.

To build a local Kubernetes cluster, run the following command:

```bash
cd scripts || exit 1 && sh create_cluster.sh local
```

or

```bash
make kubernetes-unitytree-core-dev-create-cluster
```

Read more [here](local.md).

## Development

This is the development environment for the Unity Tree ecosystem. This environment is designed to be used for development and testing of the Unity Tree ecosystem.

[Development Environment Instructions](../dev/contributions.md)

## Test

Test is the testing environment for the Unity Tree ecosystem. This environment is located in the unitytree-test AWS Account

Deployment is executed through a GitHub Action, building using the Dockerfile.prod file and deploying to the EKS cluster in the test account.

## Production

Coming Soon...

## SOPs Encryption

You will need the `private.key` file to import in your key manager for decrypting files and
the `public.key` file for encrypting files.

When you get the `private.key` and the `public.key`, you need to place them here:

```bash
cp private.key ${HOME}/.unitytree && cp public.key ${HOME}/.unitytree
# Should be ${HOME}/.unitytree/private.key
# Should be ${HOME}/.unitytree/public.key
```
Once the files are located in the correct location,
you will need to import them with the gpg tool.

```bash
gpg --import ${HOME}/.unitytree/public.key
gpg --import ${HOME}/.unitytree/private.key
```

Now you can encrypt files (YAML) with SOPs:
To set the UT_FINGERPRINT environment variable, you can run the following command:

```bash
UT_FINGERPRINT="$(gpg --list-secret-key ${KEY_NAME} | sed -n 2,2p | tr -d '[:space:]')"
```

Where `KEY_NAME` is the name of the key you imported.
Hint: "dev.unitytree.com" is the name of the key for the 
development environment _(Kubernetes)_.

```bash
sops -e -i --encrypted-regex '^(keys|in|file)$' --pgp $UT_FINGERPRINT $FILE
```

The above command will find keys in the file and encrypt them with the public key.

To decrypt the file, you can run the following command:

```bash
sops -d $FILE
```

or to decrypt and edit the file in place:

```bash
sops -d -i $FILE
```
