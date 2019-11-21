#!/bin/bash

AD_GROUPS="$(az ad group list --query "[].{displayName:displayName}" --output table | awk 'NR>2' | grep -i openshift)"
OCP_GROUPS="$(oc get groups | awk 'NR>1' | awk '{ print $1 }' )"
#OCP_USERS="$(oc get groups | awk 'NR>1' | awk '{ $1=""; print $0 }' | tr ',' ' '  )"

echo ${OCP_GROUPS[@]}

#User sync Creation
for USERS in $AD_GROUPS;
do  AD_USERS="$(az ad group member list --group $USERS --query "[].{userPrincipalName:userPrincipalName}" --output table | awk 'NR>2')" 
CREATE_AD_USERS="$(echo $USERS $AD_USERS)"
#echo ${CREATE_AD_USERS[@]} " test "
 for OCP in $OCP_GROUPS;
 do  OCP_USERS="$(oc get groups | awk 'NR>1' | awk '{ $1=""; print $0 }' | tr ',' ' '  )"
     echo $OCP_USERS
 done
#AD_USERS_DELETE="$(echo $CREATE_AD_USERS )"
#echo $AD_USERS_DELETE 
#AD_USERS_TEMP="$(echo ${CREATE_AD_USERS[@]} ${OCP_GROUPS[@]} | tr ' ' '\n' | uniq -d))"
#echo $AD_USERS_TEMP
#echo $CREATE_AD_USERS  
#echo ${OCP_GROUPS[@]}
#echo $AD_USERS_TEMP
#echo " " ;
#echo " " ;
#oc adm groups add-users $USERS $AD_USERS;
done


#TEMP_GROUP_ARRAY="$(echo ${OCP_GROUPS[@]} ${AD_GROUPS[@]} | tr ' ' '\n' | sort | uniq -u)"

#echo ${AD_USERS_TO_DELETE[0]}
#for i in $AD_USERS_TO_DELETE; do echo $i; done
#AD_USERS_TEMP="$(echo ${AD_USERS_DELETE[@]} ${OCP_GROUPS[@]} | tr ' ' '\n' | uniq -u | uniq)"
#echo $AD_USERS_TEMP

#echo $AD_USERS_DELETE


#AD_USERS_DELETE="$(echo ${OCP_GROUPS[@]} ${AD_USERS_TEMP[@]} | tr ' ' '\n' | sort | uniq -d)"

#echo $AD_USERS_DELETE
