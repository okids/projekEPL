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
import requests

DATA_OUTPUT = "data/output.dat"

class WebScrapper:
	def __init__(self, DATA_OUTPUT):
		self.data = DATA_OUTPUT
		return
	def scrap(self, url):
		url = url
		scrub = requests.get(url)
		data = scrub.text		
		soup = BeautifulSoup(data, 'html.parser')
		table = soup.table
		return str(table)
	def write_output(self, string_data):
		data = open(self.data, "w")
		data.write(string_data)
		data.close
		print("done scrapping")
		return
	def main(self, url):
		string_data = self.scrap(url)
		self.write_output(string_data)
		return

app = WebScrapper(DATA_OUTPUT)
app.main("http://statspack.squawka.com/league-form-table")
