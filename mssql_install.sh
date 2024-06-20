oc new-project mssql
oc create -f restrictedfsgroupscc.yaml
oc adm policy add-scc-to-group restrictedfsgroup system:serviceaccounts:mssql%  
oc create secret generic mssql --from-literal=SA_PASSWORD="Sql2019isfast"
oc apply -f storage.yaml
oc apply -f sqldeployment.yaml

POD=$(oc get pods | grep mssql | awk {'print $1'})
oc logs $POD
