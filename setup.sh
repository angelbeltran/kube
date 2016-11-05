# set up docker configuration for minikube daemon
eval $(minikube docker-env)

# bundle all kubernetes yaml configs per directory
sh bundle-configs.sh

# get lists of current resources
RESOURCE_TYPES='persistentvolumes persistentvolumeclaims services deployments'
for RESOURCE_TYPE in $RESOURCE_TYPES; do
  COLUMN=($(kubectl get $RESOURCE_TYPE | awk '{print $1}'))
  RESOURCES=${COLUMN[@]:1}
  eval $(echo ${RESOURCE_TYPE}=\"${RESOURCES}\")
done

# find missing resources
MISSING_RESOURCES=''

MISSING_DEPS=''
MISSING_SVCS=''
MISSING_PVS=''
MISSING_PVCS=''

DEFAULT_DIRS='volumes database back-end front-end'
for DIR in $DEFAULT_DIRS; do
  JSON=$(node_modules/js-yaml/bin/js-yaml.js ${DIR}/index.yaml)
  LENGTH=$(echo $JSON | jq length)
  ((LENGTH--))
  for i in `seq 0 $LENGTH`; do
    CONFIG=$(echo $JSON | jq .[${i}])
    NAME=$(echo $CONFIG | jq .metadata.name | tr -d "\"")
    KIND=$(echo $CONFIG | jq .kind | tr -d "\"")
    if [ "$KIND" = "PersistentVolume" ]; then
      MATCH=0
      for PV in $persistentvolumes; do
        if [ "$PV" = "$NAME" ]; then
          MATCH=1
        fi
      done
      if [ "$MATCH" -eq 0 ]; then
        #MISSING_PVS+=$DIR/configs/persistent-volumes/$NAME.yaml
        #MISSING_PVS+=' '
        MISSING_RESOURCES+=$DIR/configs/persistent-volumes/$NAME.yaml
        MISSING_RESOURCES+=' '
      fi
    elif [ "$KIND" = "PersistentVolumeClaim" ]; then
      MATCH=0
      for PVC in $persistentvolumeclaims; do
        if [ "$PVC" = "$NAME" ]; then
          MATCH=1
        fi
      done
      if [ "$MATCH" -eq 0 ]; then
        #MISSING_PVCS+=$DIR/configs/persistent-volume-claims/$NAME.yaml
        #MISSING_PVCS+=' '
        MISSING_RESOURCES+=$DIR/configs/persistent-volume-claims/$NAME.yaml
        MISSING_RESOURCES+=' '
      fi
    elif [ "$KIND" = "Service" ]; then
      MATCH=0
      for SVC in $services; do
        if [ "$SVC" = "$NAME" ]; then
          MATCH=1
        fi
      done
      if [ "$MATCH" -eq 0 ]; then
        #MISSING_SVCS+=$DIR/configs/services/$NAME.yaml
        #MISSING_SVCS+=' '
        MISSING_RESOURCES+=$DIR/configs/services/$NAME.yaml
        MISSING_RESOURCES+=' '
      fi
    elif [ "$KIND" = "Deployment" ]; then
      MATCH=0
      for DEP in $deployments; do
        if [ "$DEP" = "$NAME" ]; then
          MATCH=1
        fi
      done
      if [ "$MATCH" -eq 0 ]; then
        #MISSING_DEPS+=$DIR/configs/deployments/$NAME.yaml
        #MISSING_DEPS+=' '
        MISSING_RESOURCES+=$DIR/configs/deployments/$NAME.yaml
        MISSING_RESOURCES+=' '
      fi
    fi
  done
done

RESOURCES_MISSING=0


# supply missing resources
for RESOURCE in $MISSING_RESOURCES; do
  kubectl create -f ${RESOURCE}
  ((RESOURCES_MISSING++))
done
if [ "$RESOURCES_MISSING" -eq 0 ]; then
  echo All resources present in minikube cluster
else
  echo Generated $RESOURCES_MISSING resources
fi
