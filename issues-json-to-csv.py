#!/usr/bin/env python

import sys
import yaml
import pprint
import requests

def curl():
    url = 'https://api.github.com/repos/crazychenz/potty/issues'
    req = requests.get(url)
    return req.text

def main():
    issues = yaml.safe_load(curl())
    for issue in issues:
        print('"%s","%s","%s"' % (issue['title'], issue['body'], issue['labels'][0]['name']))
    #pprint.pprint(obj)

if __name__ == "__main__":
    main()
