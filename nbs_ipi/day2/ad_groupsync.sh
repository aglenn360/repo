#!/bin/bash

#AD_GROUPS="$(az ad group list --query "[].{displayName:displayName}" --output table | awk 'NR>2' | grep -i openshift)"
#OCP_GROUPS="$(oc get groups)"
AD_GROUPS=("Openshift_POC_ClusterAdmin" "Openshift_POC_ClusterDeveloper" "TEST" "TEST2")
OCP_GROUPS=("Openshift_POC_ClusterAdmin" "Openshift_POC_ClusterDeveloper" "TEST_AG")
TEMP_ARRAY="$(echo ${OCP_GROUPS[@]} ${AD_GROUPS[@]} | tr ' ' '\n' | sort | uniq -u)"
CREATE_ARRAY="$(echo ${TEMP_ARRAY[@]} ${AD_GROUPS[@]} | tr ' ' '\n' | sort | uniq -d | uniq)"
DELETE_ARRAY="$(echo ${OCP_GROUPS[@]} ${TEMP_ARRAY[@]} | tr ' ' '\n' | sort | uniq -d | uniq)"

AD_USERS="$(for P in $(az ad group list --query "[].{displayName:displayName}" --output table | awk 'NR>2' | grep -i openshift); do az ad group member list --group $P --query "[].{userPrincipalName:userPrincipalName}" --output table | awk 'NR>2'; done)"




echo "TEMP_ARRAY"

echo $TEMP_ARRAY
echo " "

echo "Array to create"

echo $CREATE_ARRAY
echo " "

echo "Array to Delete"

echo $DELETE_ARRAY
echo " "

#echo $AD_GROUPS

#for P in $AD_GROUPS; do az ad group member list --group $P --query "[].{userPrincipalName:userPrincipalName}" --output table | awk 'NR>2'; done

echo "Creating groups "
for P in $CREATE_ARRAY; do oc adm groups new $P; done

echo "Deleting groups"
for P in $DELETE_ARRAY; do oc delete group $P; done





