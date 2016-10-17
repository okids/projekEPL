import os
import json
import csv

#this is example getting json with win type and season 2016-2017. 
#We can change the compSeasons with 18,19,20,21,22,27,42,54, or empty CompSeasons
#we can change another stats type in ../ranked/teams/%stats%

data = os.popen( 'curl "https://footballapi.pulselive.com/football/stats/ranked/teams/wins?page=0&pageSize=20&compSeasons=54&comps=1&altIds=true" -H "Origin: https://www.premierleague.com" -H "Accept-Encoding: gzip, deflate, sdch, br" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Referer: https://www.premierleague.com/stats/top/clubs/wins" -H "Connection: keep-alive" --compressed').read()
data = data.replace('\\"',"\"")
with open('data/responsejson.txt', 'w') as outfile:
    outfile.write(data)
print data    
    

