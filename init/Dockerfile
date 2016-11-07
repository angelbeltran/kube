FROM mongo

# for parsing json
COPY jq /bin/jq
# RUN apt-get -y update && apt-get -y install jq

CMD ["/bin/sh", "/data/populate-pets.sh"]

COPY pets.json /data/pets.json
COPY populate-pets.sh /data/populate-pets.sh
