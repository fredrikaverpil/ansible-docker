# ansible-docker


## Build image

```bash
cd deploy
docker build . -t fredrikaverpil/ansible:1.0
```

## Start container, add hosts

```bash
cd deploy
docker run --detach --restart="always" --name="ansible" --hostname ansible-master --volume ${PWD}/../config/ansible:/ansible fredrikaverpil/ansible:1.0
docker exec -ti ansible bash
ln -sf /ansible/ansible.cfg /etc/ansible/ansible.cfg
ln -sf /ansible/hosts /etc/ansible/hosts
```


## Stop and remove container, image

```bash
docker stop ansible
docker rm -v ansible
docker rmi fredrikaverpil/ansible:1.0
```


## Setting up SSH authorized keys

On control machine, as root, generate `id_rsa.pub` and `ir_rsa` keys (no password):

    ssh-keygen -t rsa

You can copy the `id_rsa.pub` over to machines using `ssh-copy-id`:

```bash
ssh-copy-id -i ~/.ssh/id_rsa user@host
```

This logs into the server host, and copies keys to the server, and configures them to grant access by adding them to the authorized_keys file. The copying may ask for a password or other authentication for the server.
Only the public key is copied to the server. The private key should never be copied to another machine.


Add machines to `/etc/ansible/hosts`:

```
[farm]
192.168.0.101
192.168.0.102
192.168.0.103
```

Test it out from the ansible control machine:

```bash
ssh-agent bash
ssh-add ~/.ssh/id_rsa

ansible all -m ping
ansible all -a "/bin/echo hello"
```


### Using specified usernames/passwords for SSH connections (no ssh-agent)

In the `/etc/ansible/hosts`, specify e.g:

```
[farm:vars]
ansible_user=vagrant
ansible_pass=vagrant
ansible_connection=ssh
```


## Run playbook examples

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
