#!/usr/bin/env python
# -*- coding: utf-8 -*-
# eplvisualizer.py
# visualize epl stats data

import matplotlib.pyplot as plt
import csv

class VisualizEPL():
	def __init__(self):
		with open('data/csv/test.csv','rb') as f:
			data = 	list(csv.reader(f))
		self.goals = [i[1] for i in data]
		self.wins = [i[2] for i in data]
		self.losses = [i[3] for i in data]
		self.points = [i[22] for i in data]
		return
	def main(self):
		print(self.points)
		return

if __name__ == '__main__':
	app = VisualizEPL()
	app.main()

#~ plt.plot([1,2,3,4], [1,4,9,16], 'bo')
#~ plt.plot([3,5,1,2], [1,4,9,16], 'r*')
#~ plt.axis([0, 6, 0, 20])
#~ plt.show()
