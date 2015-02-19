#!/usr/bin/python
# -*- coding: utf-8 -*-

import subprocess
from ansible import utils, errors

class LookupModule(object):

	def __init__(self, basedir=None, **kwargs):
		self.basedir = basedir

	def run(self, terms, inject=None, **kwargs):
		terms = utils.listify_lookup_plugin_terms(terms, self.basedir, inject)

		ret = []
		for term in terms:
			p = subprocess.Popen("cat " + term, cwd=self.basedir, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
			(stdout, stderr) = p.communicate()
			if p.returncode == 0:
				for line in stdout.splitlines():
					p, r, v = line.split(",")
					ret.append({"path":p, "repo":r, "version":v})
			else:
				raise errors.AnsibleError("lookup_plugin.lines(%s) returned %d" % (term, p.returncode))

		return ret