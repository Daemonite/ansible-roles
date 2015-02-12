#!/usr/bin/python
# -*- coding: utf-8 -*-

from ansible import utils, errors

def firstword(value=''):
    ''' Return the first item in a space separated string '''

    if not isinstance(value, basestring):
        value = str(value)

    return value.split(" ")[0]

class FilterModule(object):

    def filters(self):
        return {
        	'firstword' : firstword
        }
