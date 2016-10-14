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

def main(url):
	url = url
	scrub = requests.get(url)
	data = scrub.text		
	soup = BeautifulSoup(data, 'html.parser')
	table = soup.table
	
	data = open("data/output.dat", "w")
	data.write(str(table))
	data.close
	
	print("-- done scrapping --")
	return

main("http://statspack.squawka.com/league-form-table")
