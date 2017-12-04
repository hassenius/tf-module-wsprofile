import os, sys, json

optionjson = '/tmp/wsadmin-profile-create-config.yaml'

# Read parameter items
with open(optionjson, 'r') as stream:
  o = json.load(stream)


parameters = ''
if len(o) > 0:
  for key, val in o.iteritems():
    parameters += ' -%s %s' % (key, val)

print parameters
