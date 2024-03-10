#!/bin/bash
sudo yum install docker -y
sudo systemctl start docker
sudo docker image pull tamotito/node_inventory_ui:v1
sudo docker run -d -p 3000:3000 tamotito/node_inventory_ui:v1
