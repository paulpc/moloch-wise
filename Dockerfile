FROM node:8.16-alpine

# Create app directory
WORKDIR /data/moloch/wiseService/
RUN apk add --no-cache su-exec python make g++

# Install app dependencies

COPY package.json /data/moloch/wiseService/package.json
RUN npm install --production

RUN addgroup -S wiseservice && adduser -S -G wiseservice wiseservice 

# Bundle app source
COPY moloch/wiseService/*.js /data/moloch/wiseService/
COPY moloch/wiseService/.jshintrc /data/moloch/wiseService/
COPY wise_entry.sh /data/moloch/wiseService/

# COPY enrichment /data/wise/
RUN chown -R wiseservice /data/moloch/wiseService
RUN chmod +xxx /data/moloch/wiseService/wise_entry.sh

USER wiseservice
EXPOSE 8081
ENTRYPOINT [ "/data/moloch/wiseService/wise_entry.sh" ]
CMD ["wise"]