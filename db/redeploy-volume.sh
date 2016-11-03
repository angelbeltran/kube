# remove persistent volume claim
kubectl delete -f persistent-volume-claim.yaml
# remove persistent volume
kubectl delete -f persistent-volume.yaml
# deploy persistent volume
kubectl create -f persistent-volume.yaml
# deploy persistent volume claim
kubectl create -f persistent-volume-claim.yaml
