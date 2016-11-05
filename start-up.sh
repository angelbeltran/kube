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
        MISSING_PVS+=$DIR/configs/persistent-volumes/$NAME.yaml
        MISSING_PVS+=' '
      fi
    elif [ "$KIND" = "PersistentVolumeClaim" ]; then
      MATCH=0
      for PVC in $persistentvolumeclaims; do
        if [ "$PVC" = "$NAME" ]; then
          MATCH=1
        fi
      done
      if [ "$MATCH" -eq 0 ]; then
        MISSING_PVCS+=$DIR/configs/persistent-volume-claims/$NAME.yaml
        MISSING_PVCS+=' '
      fi
    elif [ "$KIND" = "Service" ]; then
      MATCH=0
      for SVC in $services; do
        if [ "$SVC" = "$NAME" ]; then
          MATCH=1
        fi
      done
      if [ "$MATCH" -eq 0 ]; then
        MISSING_SVCS+=$DIR/configs/services/$NAME.yaml
        MISSING_SVCS+=' '
      fi
    elif [ "$KIND" = "Deployment" ]; then
      MATCH=0
      for DEP in $deployments; do
        if [ "$DEP" = "$NAME" ]; then
          MATCH=1
        fi
      done
      if [ "$MATCH" -eq 0 ]; then
        MISSING_DEPS+=$DIR/configs/deployments/$NAME.yaml
        MISSING_DEPS+=' '
      fi
    fi
  done
done

RESOURCES_MISSING=0

# supply missing resources
for PV in $MISSING_PVS; do
  kubectl create -f ${PV}
  RESOURCES_MISSING=1
done
for PVC in $MISSING_PVCS; do
  kubectl create -f ${PVC}
  RESOURCES_MISSING=1
done
for SVC in $MISSING_SVCS; do
  kubectl create -f ${SVC}
  RESOURCES_MISSING=1
done
for DEP in $MISSING_DEPS; do
  kubectl create -f ${DEP}
  RESOURCES_MISSING=1
done

if [ "$RESOURCES_MISSING" -eq 0 ]; then
  echo All resources present in minikube cluster
fi


# start koa proxy
#node .
