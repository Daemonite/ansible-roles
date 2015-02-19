#!/usr/bin/python
# -*- coding: utf-8 -*-

import re
from ansible import utils, errors

def unarchiveroot(value=''):
    ''' Return the first child directory created in the archive output '''

    if not isinstance(value, basestring):
        value = str(value)

    flags = re.I + re.M + re.S

    _re = re.compile(".*?creating: (.*?)/\n.*", flags=flags)
    return _re.sub("\\1", value)

class FilterModule(object):

    def filters(self):
        return {
        	'unarchiveroot' : unarchiveroot
        }
