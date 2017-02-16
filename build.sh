#!/usr/bin/env bash

ORIGINAL_DOCKERFILE=Dockerfile.httpd.original
ADDON_DOCKER_FILE=Dockerfile.addon
TAG=`date +"%Y-%m-%d-%H-%M-%S"`

curl -o ${ORIGINAL_DOCKERFILE} https://raw.githubusercontent.com/docker-library/httpd/b95f1aba991d613f971fe8c66dc23fb4d8f3e9a7/2.4/alpine/Dockerfile

# Thanks to http://stackoverflow.com/questions/10107459/replace-a-word-with-multiple-lines-using-sed
DATA="$(cat ${ADDON_DOCKER_FILE})"
ESCAPED_DATA="$(echo "${DATA}" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/\$/\\$/g')"
cat ${ORIGINAL_DOCKERFILE} | sed 's~EXPOSE 80~'"${ESCAPED_DATA}"'~' > Dockerfile

#sed -i 's/www-data/grimlock/g' Dockerfile

docker build -t portnumber53/docker-httpd:${TAG} . \
  && docker push portnumber53/docker-httpd:${TAG} \
  && echo "Pushed image successfuly."
