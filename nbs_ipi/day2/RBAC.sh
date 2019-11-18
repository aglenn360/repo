#!/bin/bash



#oc adm policy remove-cluster-role-from-group basic-user system:authenticate


OCP_GROUPS="$(oc get groups | awk 'NR>1' | awk '{ print $1 }' )"



for GROUP in $OCP_GROUPS; 
do  
  if [[ "$GROUP" =~ "Admin"  ]]; then
  echo "Admin" $GROUP
  oc adm policy add-cluster-role-to-group cluster-admin $GROUP
  elif [[ "$GROUP" =~ "user"  ]]; then
  echo "user" $GROUP
  oc adm policy add-cluster-role-to-group basic-user $GROUP
  elif [[ "$GROUP" =~ "Dev"  ]]; then
  oc adm policy add-cluster-role-to-group basic-user $GROUP
  echo "dev" $GROUP
  fi
done




