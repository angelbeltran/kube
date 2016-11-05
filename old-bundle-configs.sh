DIRS="front-end back-end db volumes"
FILE_NAMES="service.yaml deployment.yaml persistent-volumes.yaml persistent-volume-claims.yaml"

function bundle_configs {
  # make sure the director(y|ies) exists
  if [ "$1" = "" ]; then
    echo No directory specified to bundle-configs
    return
  elif [ ! -d "$1" ]; then
    echo Directory $1 does not exist
    return
  fi
  # move into directory bundle configs into one
  cd $1
  INDEX_FILE=''
  for FILE_NAME in $FILE_NAMES; do
    if [ -e "configs/$FILE_NAME" ]; then
      INDEX_FILE+=$(cat configs/$FILE_NAME)
      INDEX_FILE+="\n---\n"
    fi
  done
  if [ "$INDEX_FILE" != '' ]; then
    echo "$INDEX_FILE" > index.yaml
  fi
  cd ..
}

if [ "$1" = "" ]; then
  for DIR in $DIRS; do
    bundle_configs $DIR
  done
else
  for DIR in "$@"; do
    bundle_configs $DIR
  done
fi
