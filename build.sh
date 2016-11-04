CWD=$(pwd)
DIRS="front-end back-end"
for DIR in $DIRS; do
  # move into the directory
  cd $DIR

  # run webpack if a webpack config is present
  if [ -e "webpack.config.js" ]; then
    webpack
  elif [ -e "webpack.config.json" ]; then
    webpack
  fi

  # build latest docker image
  VERSION=$(cat version)
  ((VERSION++))
  if [ $VERSION -gt 100 ]; then # remove old versions if there get to be too many
    echo Cleaning up old images...
    for i in `seq 1 100`; do
      docker rmi ${IMAGE}:v${i}
    done
    VERSION=1
  fi
  IMAGE=$(cat image)
  docker build -t ${IMAGE}:v${VERSION} .            # next version
  if [ "$(docker images | grep ${IMAGE} | grep latest)" != "" ]; then
    docker rmi ${IMAGE}:latest                      # remove previous "latest" tag
  fi
  docker tag ${IMAGE}:v${VERSION} ${IMAGE}:latest   # mark as "latest"
  echo $VERSION > version

  # return to root of project
  cd $CWD
done
