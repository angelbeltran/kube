DEFAULT_DIRS="front-end back-end database"

function delete_resources {
  sh bundle-configs.sh $DIR
  kubectl delete -f ${DIR}/index.yaml 2>/dev/null # we don't care if some of the resources didn't exist
}

# remove all deployments and services
if [ "$1" != "" ]; then
  for DIR in "$@"; do
    delete_resources $DIR
  done
else
  for DIR in $DEFAULT_DIRS; do
    delete_resources $DIR
  done
fi

exit 0 # to cover up errors thrown when attempt to delete nonexistent resources
