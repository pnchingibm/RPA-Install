# RPA-Install



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
