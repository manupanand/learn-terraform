#!/bin/bash

# Define log file
export AWS_USER=$TF_VAR_aws_user
export AWS_PASSWORD=$TF_VAR_aws_password
export role_name=$TF_VAR_role_name
export remote_ip=$TF_VAR_remote_ip
LOG_FILE="/var/log/startup_script.log"
sudo touch $LOG_FILE
sudo chmod 666 $LOG_FILE
echo "AWS_USER: ${AWS_USER}" | tee -a /var/log/startup_script.log
echo "AWS_PASSWORD: ${AWS_PASSWORD}" | tee -a /var/log/startup_script.log
echo "REMOTE_IP: ${remote_ip}" | tee -a /var/log/startup_script.log
echo $LOG_FILE
# Redirect stdout and stderr to log file


echo "Starting script execution at $(date)"
sudo dnf install -y sshpass &>>$LOG_FILE
sudo dnf install -y rsyslog &>>$LOG_FILE

sudo systemctl enable rsyslog
sudo systemctl start rsyslog 
sleep 30
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config | tee -a $LOG_FILE
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config | tee -a $LOG_FILE
sudo sed -i 's/^#ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config | tee -a $LOG_FILE
sudo sed -i 's/^ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config | tee -a $LOG_FILE
sudo sed -i 's/^#ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config | tee -a $LOG_FILE
sudo sed -i 's/^#UsePAM no/UsePAM yes/' /etc/ssh/sshd_config | tee -a $LOG_FILE
sudo sed -i 's/^UsePAM no/UsePAM yes/' /etc/ssh/sshd_config | tee -a $LOG_FILE
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf | tee -a $LOG_FILE
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf | tee -a $LOG_FILE
sudo sed -i 's/^ssh_pwauth: false/ssh_pwauth: true/' /etc/cloud/cloud.cfg | tee -a $LOG_FILE
sleep 60
sudo cloud-init clean | tee -a $LOG_FILE
sudo cloud-init init  | tee -a $LOG_FILE
sleep 60
sudo systemctl restart sshd  | tee -a $LOG_FILE
sudo systemctl daemon-reload

# Set the password for "ec2-user" (USE WITH CAUTION)
echo "${AWS_USER}:${AWS_PASSWORD}" | sudo chpasswd  | tee -a $LOG_FILE
sleep 120

# install ansible 
sudo dnf install -y ansible-core | tee -a $LOG_FILE



sleep 120

while ! sshpass -p "${AWS_PASSWORD}" ssh -o StrictHostKeyChecking=no "${AWS_USER}"@"${remote_ip}" "[ -e /tmp/execute.sh ]"; do
    echo "File not found, waiting..." 
    sleep 10 
done
sleep 30
sshpass -p "${AWS_PASSWORD}" scp -o StrictHostKeyChecking=no "${AWS_USER}"@"${remote_ip}":/tmp/execute.sh /tmp/execute.sh | tee -a /var/log/startup_script.log
sleep 30
sudo chmod +x /tmp/execute.sh  | tee -a /var/log/startup_script.log

sudo /bin/bash /tmp/execute.sh | tee -a /var/log/startup_script.log 

ansible-pull -i localhost, -U https://github.com/manupanand/learn-terraform  revice/k8s-self-manged-data-pass-test/ansible/playbook.yml  -e ansible_user=${AWS_USER} -e ansible_password=${AWS_PASSWORD} -e role_name=${role_name} | tee -a $LOG_FILE
