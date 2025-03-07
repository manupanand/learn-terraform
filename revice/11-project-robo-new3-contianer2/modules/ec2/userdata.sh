#!/bin/bash
# above is sheban- to understand it is shell script
sudo dnf install ansible 2&1 | tee -a /opt/userdata.log
# dnf install hvac for vault

# run ansible play book

ansible-pull -i localhost, -U https:github/repo/asniblerepo playbook.yaml -e env=${env} -e role_name=${role_name} vault_token=${vault_token} 2>&1 |tee -a /opt/userdata.log

#store this output in a file tee opt/userdata.log 2&1 any error also send to 1