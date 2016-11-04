#!/usr/bin/env python
# -*- coding: utf-8 -*-
# eplkiller.py
# by fnugrahendi and okids
# run : $ python eplkiller.py
# this is example getting json with win type and season 2016-2017. 
# We can change the compSeasons with 18,19,20,21,22,27,42,54, or empty CompSeasons
# we can change another stats type in ../ranked/teams/%stats%

import os
import json
import csv
import requests

class KillEPL:
	def __init__(self):
		self.params = ['goals', 'wins', 'losses', 'touches', 'own_goals', 'total_yel_card',
				'total_red_card', 'total_pass', 'total_scoring_att', 'total_offside',
				'hit_woodwork','big_chance_missed', 'total_tackle', 'total_clearance', 'clearance_off_line',
				'dispossessed', 'clean_sheet', 'saves', 'penalty_save', 'total_high_claim', 'punches']
		self.years = ['19','20','21','22', '27', '42','54']
		self.totalparam = len(self.params)
		self.pointer = 0
		return
	def main(self):
		for year in self.years:
			self.dataclub = dict()
			for param in self.params:
				self.scrap(year, param)
				data_in_json = json.dumps(self.dataclub)
			with open('data/stats'+year+'.json', 'w') as outfile:
				outfile.write(str(data_in_json))
		return
	def scrap(self, year, param):
		section_pointer = 0
		theheaders = {"Origin" : "https://www.premierleague.com", 
					"Accept-Encoding" : "gzip, deflate, sdch, br",
					"Accept-Language" : "en-US,en;q=0.8",
					"User-Agent" : "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
					"Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8",
					"Accept" : "*/*",
					"Referer" : "https://www.premierleague.com/stats/top/clubs/wins",
					"Connection" : "keep-alive"}
		seasons = year;
		theparams = { 'page' : '0', 'pageSize' : '20', 'compSeasons' : seasons, 'comps' : '1', 'altIds' : 'true'}
		data = requests.get("https://footballapi.pulselive.com/football/stats/ranked/teams/"+param+"",
							headers = theheaders,
							params = theparams)
		print('\nscrapping '+param+' section '+year+'\n')
		datajson = data.text
		datajson = json.loads(datajson)
		datajson = datajson['stats']['content']
		for club in datajson:
			clubname = str(club['owner']['name'])
			if(clubname == 'AFC Bournemouth'):
					clubname = 'Bournemouth'
			if(self.pointer==0):
				self.dataclub = {clubname : {str(club['name']) : club['value']}}
			else:
				try:
					self.dataclub[clubname][str(club['name'])] = club['value']
				except Exception, e:
					self.dataclub[clubname] = {str(club['name']) : club['value']}
					print(str(e))
			section_pointer += 1
			print(str(club['owner']['name'])) 
		self.pointer += 1
		return

app = KillEPL()
app.main()
