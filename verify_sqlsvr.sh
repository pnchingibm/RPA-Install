SERVERIP=$(oc cluster-info | grep -o 'https://[^:]\+' | awk -F '//' '{print $2}')
PORT=32433
sqlcmd -Usa  -S$SERVERIP,$PORT -Q"SELECT @@version"
