# connection info
#   host: database

PETS=$(cat pets.json)
CMDS="use test\n"
for i in `seq 0 $(($(echo $PETS | jq length) - 1))`; do
  PET=$(echo $PETS | jq .[$i])
  NAME=$(echo $PET | jq .name )
  CMDS+="db.pets.update({ name: $NAME }, $PET, { upsert: true })\n"
done

# upsert the documents
echo $CMDS | mongo --host database
