dir="${0%/*}"
VERSION=$(cat ${dir}/version)
kubectl set image deployment/back-end back-end=back-end:v$VERSION
