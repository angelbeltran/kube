# kubectl won't update the image if the tags are the same. this rules out using the latest tag
# TODO remove the IFS usage, if not needed
IF=$IFS
DIRS="front-end back-end"
for DIR in $DIRS; do
  IMAGE=$(cat ${DIR}/image)
  # get latest version
  IFS=$'\n'

  line=$(docker images | grep ${IMAGE})
  ary=($line)

  IFS=$'\r'
  max=0
  for x in ${ary[@]}; do
    version=$(echo $x | awk '{print $2}')
    if [ $version != 'latest' ]; then
      version=${version:1}
      if [ "$version" -gt "$max" ]; then
        max=$version
      fi
    fi
  done

  kubectl set image deployment/${IMAGE} ${DIR}=${IMAGE}:v$max

  IFS=$IF
done
