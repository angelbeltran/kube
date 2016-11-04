DIRS="front-end back-end db"
for DIR in $DIRS; do
  kubectl create -f ${DIR}/index.yaml
done
