DEFAULT_DIRS="front-end back-end database volumes"
CONFIG_DIRS="services deployments persistent-volumes persistent-volume-claims"

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
  # build the index.yaml file contents
  INDEX_FILE=''
  # find all the valid files and add their contents
  for CONFIG_DIR in $CONFIG_DIRS; do
    if [ -d "configs/$CONFIG_DIR" ]; then
      FILE_NAMES=$(ls configs/$CONFIG_DIR)
      for FILE_NAME in $FILE_NAMES; do
        INDEX_FILE+=$(cat configs/$CONFIG_DIR/$FILE_NAME)
        INDEX_FILE+="\n---\n"
      done
    fi
  done
  # output the bundled contents to the index.yaml
  if [ "$INDEX_FILE" != '' ]; then
    echo "$INDEX_FILE" > index.yaml
  fi
  # move back up
  cd ..
}

if [ "$1" = "" ]; then
  for DIR in $DEFAULT_DIRS; do
    bundle_configs $DIR
  done
else
  for DIR in "$@"; do
    bundle_configs $DIR
  done
fi
