# remove all deployments and services
DIRS="front-end back-end db"
for DIR in $DIRS; do
  kubectl delete -f ${DIR}/index.yaml
done
