import os
import json
import csv
import requests

#this is example getting json with win type and season 2016-2017. 
#We can change the compSeasons with 18,19,20,21,22,27,42,54, or empty CompSeasons
#we can change another stats type in ../ranked/teams/%stats%
#we can change the future

params = ['wins', 'losses', 'touches', 'own_goals', 'total_yel_card',
'total_red_card', 'goals', 'total_pass', 'total_scoring_att', 'total_offside',
'hit_woodwork','big_chance_missed', 'total_tackle', 'total_clearance', 'clearance_off_line',
'dispossessed', 'clean_sheet', 'saves', 'penalty_save', 'total_high_claim', 'punches']
years = ['19','20','21','22','27','42','54']
totalparam = len(params)
pointer = 0
dataclub = dict()
for year in years:
	for param in params:
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
		print('scrapping '+param+' section \n')
		datajson = data.text
		datajson = json.loads(datajson)
		datajson = datajson['stats']['content']
		i=0
		section_pointer = 0
		totalclub = 0
		for club in datajson:
			clubname = str(club['owner']['name'])
			if(clubname == 'AFC Bournemouth'):
					clubname = 'Bournemouth'
			if(pointer==0):
				dataclub = {clubname : [club['value']]}
			else:
				try:
					dataclub[clubname].append(club['value'])
				except:
					dataclub[clubname] = [club['value']]
			totalclub += 1
			section_pointer += 1
			print(str(club['owner']['name'])) 
		pointer += 1
	with open('data/response'+year+'.txt', 'w') as outfile:
		outfile.write(str(dataclub))
