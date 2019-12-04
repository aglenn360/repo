#! /bin/bash




CLUSTER_NAME="MY-TEST-CLUSTER"





	sed -i  "s/CLUSTER_NAME/$CLUSTER_NAME/g" $machinesets
