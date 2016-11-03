dir="${0%/*}"
VERSION=$(cat ${dir}/version)
kubectl set image deployment/front-end front-end=front-end:v$VERSION
