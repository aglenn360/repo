#!/bin/bash

AD_GROUPS="$(az ad group list --query "[].{displayName:displayName}" --output table | awk 'NR>2' | grep -i openshift)"
OCP_GROUPS="$(oc get groups | awk 'NR>1' | awk '{ print $1 }' )"
TEMP_GROUP_ARRAY="$(echo ${OCP_GROUPS[@]} ${AD_GROUPS[@]} | tr ' ' '\n' | sort | uniq -u)"
CREATE_GROUP_ARRAY="$(echo ${TEMP_GROUP_ARRAY[@]} ${AD_GROUPS[@]} | tr ' ' '\n' | sort | uniq -d | uniq)"
DELETE_GROUP_ARRAY="$(echo ${OCP_GROUPS[@]} ${TEMP_GROUP_ARRAY[@]} | tr ' ' '\n' | sort | uniq -d | uniq)"



#OCP_USERS="$(oc get groups | awk 'NR>1' | tr ',' ' ')"

#Group Sync from Azure to OCP
echo "TEMP_ARRAY"

echo $TEMP_GROUP_ARRAY
echo " "

echo "Array to create"

echo $CREATE_GROUP_ARRAY
echo " "

echo "Array to Delete"

echo $DELETE_GROUP_ARRAY
echo " "

echo "Creating groups "
for ADD_GROUPS in $CREATE_GROUP_ARRAY; do oc adm groups new $ADD_GROUPS; done

echo "Deleting groups"
for REMOVE_GROUPS in $DELETE_GROUP_ARRAY; do oc delete group $REMOVE_GROUPS; done




#User sync Creation
for USERS in $AD_GROUPS;
do  AD_USERS="$(az ad group member list --group $USERS --query "[].{userPrincipalName:userPrincipalName}" --output table | awk 'NR>2')" ;
echo " " ;
echo " " ;
IFS=$'\n';
CREATE_AD_USERS="$(echo $USERS $AD_USERS)"; 
echo $CREATE_AD_USERS;
echo " " ;
echo " " ;
oc adm groups add-users $USERS $AD_USERS;
done

