# Build a Fully Functional RPA Server Environment

The documentation for installing RPA Server on OpenShift does not cover all the supporting compoents and configurations to build a fully functional environment. The information and artifacts provided in this repo help you to build a functional RPA server environment. 

To setup an RPA server environment on your own OCP cluster, you will need to do the following:  
    1. Install MQ Server. The detail installation information is in the documentation.  
    2. Install an MSSQL server.  
    3. Install RPA Operator.  
    4. Create an RPA Instance.  
    5. Install an LDAP server.  
    6. Configure LDAP as Identify Provider for CPFS (Cloud Pak Foundational Service).  

<span style="font-size: 22px;"><b>Install MQ Server</b></span>
---
When installing MQ Operator, the MQ version must be aligned with the RPA version. The following link provides the version references. 
    https://www.ibm.com/docs/en/rpa/23.0?topic=openshift-versioning-reference  
    https://www.ibm.com/docs/en/rpa/21.0?topic=openshift-versioning-reference

<span style="font-size: 22px;"><b>Install MSSQL Server</b></span>
---
MSSQL Server installation consists of the following steps: 
   - Create a namespace for MSSQL server.  
   - Create security context constaints.  
   - Apply security context group.  
   - Create secret for login credential.  
   - Create PVC for the database.  
   - Create MSSQL Deployment and Service.   

You can run the following commands to complete the above steps.
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
```

You can verify your MSSQL Server installation by running the following command (assuming you use the same port number from the above): 
```
./verify-sqlsvr.sh
```

<span style="font-size: 22px;"><b>Configure LDAP connection</b></span>
---
```
Base DN: dc=example,dc=org  
Connection DN: cn=admin,dc=example,dc=org  
Connection DN password: adminpassword  
URL: ldap://<URL OF THE "OPENLDAP" SERVICE>:<port>  
Group Filter: (&(cn=%v)(objectclass=groupOfNames))  
Users Filter: (&(uid=%v)(objectclass=inetorgperson))  
Group ID Map: *:cn  
User ID Map: *:uid  
Group Member ID Map: groupOfNames:member  
```
