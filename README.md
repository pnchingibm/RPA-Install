# RPA-Install

To setup an RPA server environment on your own OCP cluster, you will need to do the following:
  1. Install MQ Server. The detail installation information is in the documentation.
  2. Install an MSSQL server.
  3. Install an LDAP server. 

Install MSSQL Server
  - Create a namespace for MSSQL server
  - Create security context constaints
  - Apply security context group
  - Create secret for login credential
  - Create PVc for the database
  - Create MSSQL Deployment and Service

You can run the following commands to install MSSQL server.


```
oc new-project mssql
oc create -f restrictedfsgroupscc.yaml
oc adm policy add-scc-to-group restrictedfsgroup system:serviceaccounts:mssql%  
oc create secret generic mssql --from-literal=SA_PASSWORD="Sql2019isfast"
oc apply -f storage.yaml
oc apply -f sqldeployment.yaml
```

For RPA Server to access the MSSQL server service, the cluster internal IP address can be used. However, if you want to verify if the MSSQL server is installed correctly, you will need to create a Nodeport for the service. 

To create the Nodeport, you can run the following command: 
```
oc expose service mssql-service --type=NodePort --port=32433
'''

You can verify your MSSQL Server installation by running the following command (assuming you use the same port number from the above): 
```
./verify-sqlsvr.sh
```


Configure LDAP connection


Base DN: dc=example,dc=org
Connection DN: cn=admin,dc=example,dc=org
Connection DN password: adminpassword
URL: ldap://<URL OF THE "OPENLDAP" SERVICE>:<port>
Group Filter: (&(cn=%v)(objectclass=groupOfNames))
Users Filter: (&(uid=%v)(objectclass=inetorgperson))
Group ID Map: *:cn
User ID Map: *:uid
Group Member ID Map: groupOfNames:member
