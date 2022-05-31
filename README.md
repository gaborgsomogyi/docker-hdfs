# Docker file for Hadoop 3 HDFS

Minimal docker kerberos secured Hadoop 3 HDFS server for testing purposes.\
Please be aware that kerberos is not embedded so [docker KDC](https://github.com/gaborgsomogyi/docker-kdc) is needed.

## How to build
```
eval $(minikube docker-env)
docker build -t gaborgsomogyi/hdfs:latest .
```

## How to run
Here one can choose from 2 deployments:
* K8S
```
mkdir -p ${HOME}/share
minikube start --mount-string="${HOME}/share:/share" --mount
kubectl apply -f hdfs.yaml
kubectl delete pod/hdfs
```

* Docker
```
./run-hdfs.sh
```

## Access the container
* K8S
```
kubectl exec -it hdfs -- bash
```

* Docker
```
docker exec -it hdfs bash
```
