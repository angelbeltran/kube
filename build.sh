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
  IMAGE=$(cat image)
  docker build -t ${IMAGE}:v${VERSION} .
  echo $VERSION > version

  # return to root of project
  cd $CWD
done
