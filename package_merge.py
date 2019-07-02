#!/usr/local/bin/python3

import json

mol = json.load(open('./moloch/package.json'))
wisemol = json.load(open('./moloch/wiseService/package.json'))
for dep in mol['dependencies']:
    if not dep in wisemol['dependencies']:
        wisemol['dependencies'][dep]=mol['dependencies'][dep]
json.dump(wisemol, open('package.json','w'))