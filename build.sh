# build front end components
cd front-end
webpack
cd ..
VERSION=$(cat front-end/version)
((VERSION++))
docker build -t front-end:v$VERSION front-end              # build next version
echo $VERSION > front-end/version

# build back end components
VERSION=$(cat back-end/version)
((VERSION++))
docker build -t back-end:v$VERSION back-end              # build next version
echo $VERSION > back-end/version
