#!/bin/bash

hostSet=$1
port=$2
#if [ ! -s $hostfile ] 
#then	
#  echo "Hostfile Empty"
#  exit
#fi
#if [ ! -s $portfile ]
#then	
#  echo "Portfile Empty"
#  exit
#fi
for host in {1..254}; do
  timeout .1 bash -c "echo >/dev/tcp/$hostSet.$host/$port" 2>/dev/null &&
  # Added more user friendly output    
  echo "Active Host: $hostSet.$host  Port Scanned:  $port"; 
done
