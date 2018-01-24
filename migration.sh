#!/bin/bash

set -x

if [[ ! -d "/data" ]]
then
  mkdir /data
fi



export PGPASSWORD=${PGPASSWORD_IN}
db=($(psql -h ${PGHOST_IN} -p ${PGPORT_IN} -U ${PGUSER_IN} -d postgres -c "SELECT datname FROM pg_database WHERE datistemplate = false;" |awk 'NR>2 {print $1}' |head -n -2))

for db in ${db[@]};
do
 if [[ ${db} =~ ^(|-------------------------------------|rdsadmin|postgres|rows\)|datname|-|\([0-9][0-9])$ ]]
 then
    continue
 fi
    export PGPASSWORD=${PGPASSWORD_IN}
    pg_dump -Fd -j 8 -bcCO -h ${PGHOST_IN} -p ${PGPORT_IN} -U ${PGUSER_IN} -f "/data/${db}" ${db}
    export PGPASSWORD=${PGPASSWORD_OUT}
    pg_restore -Fd -cCO -j 8 -h ${PGHOST_OUT} -p ${PGPORT_OUT} -U ${PGUSER_OUT} -d postgres /data/${db}/
done
