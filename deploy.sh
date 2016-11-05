DIRS="front-end back-end database"
for DIR in $DIRS; do
  sh bundle-configs.sh $DIR
  kubectl create -f ${DIR}/index.yaml
done
