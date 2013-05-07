#!/bin/bash

echo -e "Please enter origin IP (46.332.197.78): "
read origin_ip

echo -e "Please enter pem key (file.pem): "
echo -e "Note: File must be in current directory, with chmod 600!"
read pem_key

echo -e "Please enter Wowza license key (lickey): "
read license_key

edge=()
while IFS= read -r -p "Please enter edge IP (end with an empty line): " line;
do
  [[ $line ]] || break  # break if line is empty
  edge+=("$line")
done

printf '%s\n' "Edge IPs read:"
printf '  «%s»\n' "${edge[@]}"

# origin

read -p "Do you want to configure origin? " reply
if [[ $reply =~ ^[Yy]$ ]]
then
  echo -e "Configuring origin $origin_ip \n"

  read -p "Shall I update the server? " update_me
  if [[ $update_me =~ ^[Yy]$ ]]
  then
    ssh -t -i ./$pem_key ec2-user@$origin_ip "sudo yum -y update"
  fi

  ssh -t -i ./$pem_key ec2-user@$origin_ip "sudo mkdir -p /opt/script; sudo chown ec2-user:ec2-user /opt/script"
  scp -i $pem_key -r ./ ec2-user@$origin_ip:/opt/script/

  ssh -t -i ./$pem_key ec2-user@$origin_ip "chmod +x /opt/script/*"
  ssh -t -i ./$pem_key ec2-user@$origin_ip "cd /opt/script; sudo ./multiple_origin_3.5.2.sh $license_key"
  ssh -t -i ./$pem_key ec2-user@$origin_ip "cd /opt/script; sudo ./load_balancer_listener_3.5.2.sh "
fi

read -p "Do you want to configure edges? " reply2
if [[ $reply2 =~ ^[Yy]$ ]]
then
  echo -e "Configuring edges ..."
  for current_edge in "${edge[@]}"
  do
    echo -e "Configuring edge $current_edge ... \n"
    read -p "Shall I update the server? " update_me
    if [[ $update_me =~ ^[Yy]$ ]]
    then
      ssh -t -i ./$pem_key ec2-user@$current_edge "sudo yum -y update"
    fi
    ssh -t -i ./$pem_key ec2-user@$current_edge "sudo mkdir -p /opt/script; sudo chown ec2-user:ec2-user /opt/script"

    scp -i ./$pem_key -r ./ ec2-user@$current_edge:/opt/script/

    ssh -t -i ./$pem_key ec2-user@$current_edge "chmod +x /opt/script/*"
    ssh -t -i ./$pem_key ec2-user@$current_edge "cd /opt/script; sudo ./multiple_edge_3.5.2.sh $origin_ip $license_key"
    ssh -t -i ./$pem_key ec2-user@$current_edge "cd /opt/script; sudo ./load_balancer_sender_3.5.2.sh $origin_ip $current_edge"
  done
fi
