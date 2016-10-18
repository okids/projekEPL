import os
import json
import csv
#~ import requests

#this is example getting json with win type and season 2016-2017. 
#We can change the compSeasons with 18,19,20,21,22,27,42,54, or empty CompSeasons
#we can change another stats type in ../ranked/teams/%stats%
#we can change the future
params = ['wins', 'losses', 'touches', 'own_goals', 'total_yel_card', 'total_red_card', 'goals', 'total_pass', 'total_scoring_att',
'total_offside', 'hit_woodwork','big_chance_missed', 'total_tackle', 'total_clearance', 'clearance_off_line',
'dispossessed', 'clean_sheet', 'saves', 'penalty_save', 'total_high_claim', 'punches']
totalparam = len(params)
pointer = 0
dataclub = []
for param in params:
	command = 'curl "https://footballapi.pulselive.com/football/stats/ranked/teams/'+param+'?page=0&pageSize=20&compSeasons=54&comps=1&altIds=true" -H "Origin: https://www.premierleague.com" -H "Accept-Encoding: gzip, deflate, sdch, br" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Referer: https://www.premierleague.com/stats/top/clubs/wins" -H "Connection: keep-alive" --compressed'
	data = os.popen(command).read()
	print('scrapping '+param+' section')
	datajson = json.loads(data)
	datajson = datajson['stats']['content']
	#~ print(command)
	clubsname = []
	values = []
	valstype = []
	i=0
	for club in datajson:
		if(pointer==0):
			clubsname.append(str(club['owner']['name']))
		values.append(club['value'])
		valstype.append(str(club['name']))
		dataclub.append([str(club['owner']['name']), club['value']])
	pointer+=1

#~ clubvalue = []
#~ clubidx = 0
#~ for val in values:
	#~ clubvalue.append(

#~ for club in clubsname:
	#~ clubname = str(club['owner']['name'])
	#~ value = club['value']
	#~ dataclub.append([valtype,value])
with open('data/responsejson.txt', 'w') as outfile:
    outfile.write(str(dataclub))
print dataclub
