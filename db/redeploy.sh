# delete current database service
kubectl delete -f service.yaml
# delete current database deployment
kubectl delete -f deployment.yaml
# create database deployment
kubectl create -f deployment.yaml
# create database service
kubectl create -f service.yaml
