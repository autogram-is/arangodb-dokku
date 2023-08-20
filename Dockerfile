FROM arangodb/arangodb:latest

# Add user dokku with an individual UID
RUN adduser -u 32769 -m -U dokku
USER dokku
