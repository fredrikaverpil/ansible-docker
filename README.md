# ansible-docker


## Preparations

### Create a pair of SSH keys

Generate `id_rsa.pub` and `ir_rsa` keys (no password):

    ssh-keygen -t rsa

Copy the previously generated keys to the `ansible-docker/config/.ssh` folder.


## Build image

```bash
cd deploy
docker build . -t fredrikaverpil/ansible:1.0
```

Please note that the previously created keys are added to the image during the build.



## Run container

This will run the container and enter it, allowing for interactively working with ansible.

```bash
cd deploy
docker run --rm --interactive --tty --volume ${PWD}/../config/ansible/ansible.cfg:/etc/ansible/ansible.cfg --volume ${PWD}/../config/ansible/hosts:/etc/ansible/hosts --volume ${PWD}/../config/ansible:/ansible fredrikaverpil/ansible:1.0
```

## Container commands

The following applies only to when running interactively inside the container.


### Deploy SSH keys onto clients

You can copy the `id_rsa.pub` over to machines using `ssh-copy-id`:

```bash
ssh-copy-id -i ~/.ssh/id_rsa user@host
```

This logs into the server host, and copies keys to the server, and configures them to grant access by adding them to the authorized_keys file. The copying may ask for a password or other authentication for the server. Only the public key is copied to the server. The private key should never be copied to another machine.

This all will ensure that our control machine can get SSH access to the remote machine(s).

If you have many machines to copy the key to, this may help, use the `/ansible/tools/deploy_keys.sh`.

If the SSH keys doesn't seem to work, try this:

```bash
ssh-agent bash
ssh-add ~/.ssh/id_rsa
```

### Add hosts


Add machines to the inventory; `/etc/ansible/hosts`, example:

```
[farm]
192.168.0.101
192.168.0.102
192.168.0.103
```

Test it out from the ansible control machine:

```bash
ansible all -m ping
ansible all -a "/bin/echo hello"
```


### Using specified usernames/passwords for SSH connections (no ssh-agent)

Instead of using the deployed keys, user and password can be specified directly in the inventory `hosts` file (not recommended!).

In the `/etc/ansible/hosts`, specify e.g:

```
[farm:vars]
ansible_user=vagrant
ansible_pass=vagrant
ansible_connection=ssh
```


### Run playbook examples

```bash
# Linux
ansible-playbook /ansible/playbooks/helloworld.yml
```


# Windows support

Windows:
  * Download script (note, link is a web page): https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1
  * Run: `powershell.exe -noprofile -executionpolicy bypass -file .\ConfigureRemotingForAnsible.ps1`
  * Run: `ansible win -m win_ping`
  * Run: `ansible-playbook choco.yml`  (works!)
  * Look through AnsibleFest London 2017, Ansible & Windows: https://www.youtube.com/watch?v=U0SQ-3-QDzw


## Stop and remove container, image

```bash
docker stop ansible
docker rm -v ansible
docker rmi fredrikaverpil/ansible:1.0
```
