#!/usr/bin/env bash
#Create multiple Jmeter namespaces on an existing kuberntes cluster
#Started On January 23, 2018

working_dir=`pwd`

echo "Current list of namespaces on the kubernetes cluster:"

echo

kubectl get namespaces | grep -v NAME | awk '{print $1}'

echo

tenant="$1"
if [ -z "$tenant" ]
then
  echo "Enter the name of the new tenant unique name, this will be used to create the namespace"
  read tenant
fi

echo

#Check If namespace exists

eks kubectl get namespace $tenant > /dev/null 2>&1

if [ $? -eq 0 ]
then
  echo "Namespace $tenant exists"

fi

echo "Creating Jmeter slave nodes"

nodes=`kubectl get no | egrep -v "master|NAME" | wc -l`

echo

echo "Number of worker nodes on this cluster is " $nodes

echo

#echo "Creating $nodes Jmeter slave replicas and service"

echo

kubectl create -n $tenant -f $working_dir/jmeter_slaves_deploy.yaml

kubectl create -n $tenant -f $working_dir/jmeter_slaves_svc.yaml

echo "Creating Jmeter Master"

kubectl create -n $tenant -f $working_dir/jmeter_master_configmap.yaml

kubectl create -n $tenant -f $working_dir/jmeter_master_deploy.yaml

echo

kubectl get -n $tenant all
