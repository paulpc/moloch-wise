# moloch-wise
docker scripts to generate images for moloch wise from the code on git

To generate a docker container for the latest commit to github, run
```bash
./pseudoCD.sh
```

To generate a container for a specific tag, use the tag as a parameter:
```bash
./pseudoCD.sh v1.8.0
```

The script should be prettu verbose and should fail in case the tests do not complete successfully.