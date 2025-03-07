# #!/bin/bash
# # above is sheban- to understand it is shell script
sudo dnf install ansible 2&1 | tee -a /opt/userdata.log
# dnf install hvac for vault

# run ansible play book

ansible-pull -i localhost, -U https:github/repo/asniblerepo playbook.yaml -e env=${env} -e role_name=${docker} -e app_name=${app_name} vault_token=${vault_token} 2>&1 |tee -a /opt/userdata.log

# #store this output in a file tee opt/userdata.log 2&1 any error also send to 1

# contianer
# dnf install docker -y

# # extend volume
# growpart /dev/nvme0n1 4
# lvextend -r -L +10G /dev/mapper/RootVG-varVol