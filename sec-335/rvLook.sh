#!/bin/bash

network_prefix=$1
dns_serv=$2
for host in {1..254}; do
  timeout .1 bash -c "nslookup $network_prefix.$host $dns_serv" &&
    echo "$ip,$port";
done
