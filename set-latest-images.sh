#front-end/update.sh
VERSION=$(cat front-end/version)
kubectl set image deployment/front-end front-end=front-end:v$VERSION

#back-end/update.sh
VERSION=$(cat back-end/version)
kubectl set image deployment/back-end back-end=back-end:v$VERSION
