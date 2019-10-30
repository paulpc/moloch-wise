#!/bin/bash

# downloading the repo
git clone git@github.com:aol/moloch.git

if [ -z "$1" ] ; then
    tag="git-latest"
else
    tag="v$1"
    cd moloch
    # selecting the branch to the tag
    git checkout $tag
    cd ..
fi
# merging the dependencies for Wise
python3 package_merge.py
# building the wise container
docker build -t p4ulpc/moloch-wise:$tag .

# starting the wise container:
preswd=`pwd`
containerid=`docker run -d -v $preswd/enrichmentSample:/data/enrichment -p 127.0.0.1:8081:8081/tcp p4ulpc/moloch-wise:$tag`
docker ps
# waiting a bit then running the tests
sleep 15
if python3 wise_tests.py; then
    # if tests succeed, push it
    echo "[+] tests passed, pushing container"
    docker push p4ulpc/moloch-wise:$tag
else
    echo "[-] Womp, womp! Not passing tests"
fi

#cleaning up
docker stop $containerid
rm -rf moloch