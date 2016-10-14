#!/usr/bin/env python
# -*- coding: utf-8 -*-
#  appconfig.py
#  read config file
#
#  Copyright 2016 Ferindra Nugrahendi <ubuntu@lenovo>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed jin the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

class AppConfig:
	def __init__(self, FILEPATH):
		self.filepath = FILEPATH
		return
	def readfile(self):
		path = self.filepath
		try:
			configStream = open(path, "r")
			configData = configStream.read()
			configData = configData.split("\n")
			configOutputFile = configData[0].split("=")
			DATA_OUTPUT = configOutputFile[1]
			configURL = configData[1].split("=")
			URL = configURL[1]
		except:
			print("[ERROR] : CONFIG FILE DID NOT FOUND! ")
			print("[ERROR] : ABORTING ...  ")
			return("","")
		return (URL, DATA_OUTPUT)
