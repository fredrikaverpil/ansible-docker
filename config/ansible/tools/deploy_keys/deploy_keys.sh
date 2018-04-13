#!/bin/bash
for ip in `cat list_of_servers.txt`; do
    ssh-copy-id -i ~/.ssh/id_rsa.pub $ip
done
