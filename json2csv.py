#!/usr/bin/env python
# -*- coding: utf-8 -*-
# json to csv. json2csv.py
# by fnugrahendi
# run : $ python json2csv.py
# it load json object from all file in data/json/, write to csv
# choose write train data or test data or both
# train data is all data from season 2010/2011 to 2015/2016
# test data is all data in current season (2016/2017)

import json
import os
import csv
from eplkiller import KillEPL
from pprint import pprint

class JSON2CSV(KillEPL):
	def __init__(self, killerClass):
		self.params = killerClass.params
		self.jsonFilesName = killerClass.years
		self.trainData = self.jsonFilesName[0:6]
		self.testData = self.jsonFilesName[6:7]
		print(self.testData)
		return
	def main(self):
		option = raw_input("what do you want to write? (train / test / both)")
		if option.lower() == 'train':
			print('writing train data ...')
			self.writeCSV(self.trainData, 'train')
		elif option == 'test' :
			print('writing test data ...')
			self.writeCSV(self.testData, 'test')
		elif option == 'both' :
			print('writing train data ...')
			self.writeCSV(self.trainData, 'train')
			print('writing test data ...')
			self.writeCSV(self.testData, 'test')
		else :
			print("oops. wrong answer. try again")
			return self.main()
		return
	def writeCSV(self, jsonData, typeData):
		jsonDataMerge = dict()
		jsonObject = dict()
		headers = ['']
		for head in self.params:
			headers.append(head)
		headers.append('points')
		csvOutput = open('data/csv/'+typeData+'.csv', 'wt')
		csvWriter = csv.writer(csvOutput, quoting=csv.QUOTE_NONNUMERIC)
		csvWriter.writerow(headers)
		for jsonFile in jsonData:
			jsonObject = self.readJSON(jsonFile)
			clubs = jsonObject.keys()
			for club in clubs:
				row = []
				row.append(str(club))
				print(club)
				print('\n')
				for param in self.params:
					try:
						row.append(int(jsonObject[club][param]))
						print(param+' : '+str(jsonObject[club][param]))
					except:
						row.append(0)
						print(param+' : '+'0.0')
				try:
					wins = jsonObject[club]['wins']
				except:
					wins = 0
				try:
					losses = jsonObject[club]['losses']
				except:
					losses = 0
				draw = ((len(clubs)-1)*2) - (wins + losses)
				print('draws : '+str(draw))
				points = 3*wins + draw
				row.append(int(points))
				print('points : '+str(points))
				print('\n')
				csvWriter.writerow(row)
		csvOutput.close()
		return
	def readJSON(self, jsonFile):
		with open('data/json/stats'+jsonFile+'.json') as jsonFile :
			jsonObj = json.load(jsonFile)
		return jsonObj
		
if __name__ == '__main__':
	killerObject = KillEPL()
	app = JSON2CSV(killerObject)
	app.main()
