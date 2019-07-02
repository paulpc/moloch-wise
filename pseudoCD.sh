#!/bin/bash
git clone git@github.com:aol/moloch.git

if [ -z "$1"]; then
    tag="git-latest"
else
    tag=$1
    cd moloch
    git checkout $tag
    cd ..
fi
python3 package_merge.py

docker build -t p4ulpc/moloch-wise:$tag .

# testing it:
preswd=`pwd`
containerid=`docker run -d -v $preswd/enrichmentSample:/data/enrichment -p 127.0.0.1:8081:8081/tcp p4ulpc/moloch-wise:$tag`
docker ps
# waiting a bit then running the tests
sleep 15
if python3 wise_tests.py; then
    # if tests succed, push it
    docker push p4ulpc/moloch-wise:$tag
else
    echo "cleaning up - not passing tests"
fi

#cleaning up
docker stop $containerid
#rm -rf moloch