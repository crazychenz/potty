#!/usr/bin/env python

import sys
import yaml
import pprint
import requests

def curl():
    url = 'https://api.github.com/repos/crazychenz/potty/issues?state=all'
    req = requests.get(url)
    return req.text

def main():
    issues = yaml.safe_load(curl())
    for issue in issues:
        line = []
        line.append('"%s"' % (issue['title'] if 'title' in issue else 'Unknown'))
        line.append('"%s"' % (issue['body'] if 'body' in issue else 'Unknown'))
        line.append('"%s"' % (issue['labels'][0]['name'] if 'labels' in issue and len(issue['labels']) > 0 else 'Unknown'))
        line.append('"%s"' % (issue['milestone']['title'] if 'milestone' in issue and issue['milestone'] != None else 'Unknown'))
        print(','.join(line))
        #print('"%s","%s","%s"' % (issue['title'], issue['body'], issue['labels'][0]['name']))
    #pprint.pprint(obj)

if __name__ == "__main__":
    main()
