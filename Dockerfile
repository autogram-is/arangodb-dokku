# Pre-setup in Dokku
# 
# sudo mkdir -p /var/lib/dokku/data/storage/arango
# sudo chown 32769:32769 /var/lib/dokku/data/storage/arango
# dokku storage:mount arango /var/lib/dokku/data/storage/arango:/var/lib/arangodb3


FROM arangodb/arangodb:latest

# Add user dokku with an individual UID
RUN adduser -u 32769 -m -U dokku
USER dokku
