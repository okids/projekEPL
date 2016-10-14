#!/usr/bin/env python
# -*- coding: utf-8 -*-
#  main.py
#  scrapping football statistic website for data-analytic
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

from bs4 import BeautifulSoup
from appconfig import AppConfig
import requests

FILEPATH = "app.config"

class WebScrapper:
	def __init__(self, URL, DATA_OUTPUT):
		self.data = DATA_OUTPUT
		self.url = URL
		return
	def scrap(self):
		scrub = requests.get(self.url)
		data = scrub.text		
		soup = BeautifulSoup(data, 'html.parser')
		table = soup.table
		return str(table)
	def write_output(self, stringData):
		data = open(self.data, "w")
		data.write(stringData)
		data.close
		print("done scrapping")
		return
	def main(self):
		stringData = self.scrap()
		self.write_output(stringData)
		return

appconfig = AppConfig(FILEPATH)
config = appconfig.readfile()
if(config[0]!=""):
	app = WebScrapper(config[0], config[1])
	app.main()
