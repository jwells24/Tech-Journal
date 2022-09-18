#!/bin/bash

hostfile=$1
portfile=$2
if [ ! -s $hostfile ] 
then	
  echo "Hostfile Empty"
  exit
fi
if [ ! -s $portfile ]
then	
  echo "Portfile Empty"
  exit
fi
for host in $(cat $hostfile); do
  for port in $(cat $portfile); do
    timeout .1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null &&
	# Added more user friendly output    
      echo "Active Host: $host  Port active:  $port"
  done
done
