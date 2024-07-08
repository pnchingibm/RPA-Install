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
When installing MQ Operator, the MQ version must be aligned with the RPA version you will be installing. The following link provides the version references.  
&nbsp;&nbsp;&nbsp;&nbsp; https://www.ibm.com/docs/en/rpa/23.0?topic=openshift-versioning-reference  
&nbsp;&nbsp;&nbsp;&nbsp; https://www.ibm.com/docs/en/rpa/21.0?topic=openshift-versioning-reference  

There is no need to create a MQ manager. A MQ manager will be automaticially created by a RPA Server operand.      

<span style="font-size: 22px;"><b>Install MSSQL Server</b></span>
---
MSSQL Server installation consists of the following steps: 
&nbsp;&nbsp;&nbsp;&nbsp;- Create a namespace for MSSQL server.  
&nbsp;&nbsp;&nbsp;&nbsp;- Create security context constaints.  
&nbsp;&nbsp;&nbsp;&nbsp;- Apply security context group.  
&nbsp;&nbsp;&nbsp;&nbsp;- Create secret for login credential.  
&nbsp;&nbsp;&nbsp;&nbsp;- Create PVC for the database.  
&nbsp;&nbsp;&nbsp;&nbsp;- Create MSSQL Deployment and Service.   

You can run the following commands or execute the mssql_install.sh script to complete the above steps.
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

<span style="font-size: 22px;"><b>Create RPA Server Instance</b></span>
---
Creating an RPA Server instance is mostly staightforward. The main taks is to create a yaml file for the RPA instance. However, configuriing the license value and for the MQ version you installed and confiuring self-signed CA certificate. 

MQ License Configuration
1. Identify the version of the installed MQ instance. Use the following link the identify the license information and usage. The following is an example of the MQ License section.
   
&nbsp;&nbsp;&nbsp;&nbsp; https://www.ibm.com/docs/en/ibm-mq/9.2?topic=mqibmcomv1beta1-licensing-reference

```
spec:
  license:
    accept: true
  createRoutes: false
  webDriverUpdates:
    enabled: true
  systemQueueProvider:
    highAvailability: false
    queueManagerLicense: L-RJON-C7QG3S
    queueManagerLicenseUsage: Production
    queueManagerVersion: 9.2.5.0-r3
```
    
<span style="font-size: 22px;"><b>Configure LDAP connection</b></span>
---
Please refer to https://github.com/pnchingibm/Openldap-OCP for OpenLDAP deployment on OpenShift.
RPA Server requires SSO authentication. You will need to create an LDAP connection. The details for creating an LDAP connection can be found in the follwoing documenation:

&nbsp;&nbsp;&nbsp;&nbsp;  https://www.ibm.com/docs/en/cloud-paks/foundational-services/4.6?topic=users-configuring-ldap-connection

Specificially when creating connection to OpenLDAP, you need to select server type as "custom" and apply the following values. 

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
