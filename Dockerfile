# Pre-setup in Dokku
# 
# sudo mkdir -p /var/lib/dokku/data/storage/arango
# sudo chown 32769:32769 /var/lib/dokku/data/storage/arango
# dokku storage:mount arango /var/lib/dokku/data/storage/arango:/var/lib/arangodb3
# 
# dokku domains:set arango arango.example.com
# 
# dokku ports:add arango http:80:8529
# dokku ports:add arango https:443:8529
# dokku ports:add arango https:8529:8529
# 

FROM arangodb/arangodb:latest

USER dokku
