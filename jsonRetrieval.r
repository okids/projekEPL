require(RJSONIO)
workingDir = "C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master"
setwd(workingDir)

json_file1<-"C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master/data/stats19.json"
json_file2<-"C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master/data/stats20.json"
json_file3<-"C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master/data/stats21.json"
json_file4<-"C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master/data/stats22.json"
json_file5<-"C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master/data/stats27.json"
json_file6<-"C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master/data/stats42.json"
json_file7<-"C:/Users/Oki.OKI-PC/Documents/projekEPL-master/projekEPL-master/data/stats54.json"

dataRetrieve<-function(json_file){

	jsons<-fromJSON(json_file)

	params <- c('goals', 'wins', 'losses', 'touches', 'own_goals', 'total_yel_card',
					'total_red_card', 'total_pass', 'total_scoring_att', 'total_offside',
					'hit_woodwork','big_chance_missed', 'total_tackle', 'total_clearance', 'clearance_off_line',
					'dispossessed','saves', 'clean_sheet', 'penalty_save', 'total_high_claim', 'punches')
	json = jsons[1]
	data=(as.data.frame(json))
	data=t(data)
	len = length(data)
	features = colnames(data)

	for(param in params){
		if(!param %in% features){
			data<-cbind(data,0)
			colnames(data)[len+1]<-c(param)
			len=len+1
		}
	}

	win = data[,'wins']
	loses = data[,'losses']
	draw = 38-win-loses
	points = win*3+draw*1
	data<-cbind(data,points)
	len=len+1
	colnames(data)[len]<-c('points')
	temp3<-t(as.data.frame(data[,c(params,'points')]))
	rownames(temp3)=rownames(data)
	data=temp3


	for (i in 2:20){
		json = jsons[i]
		temp2 = (as.data.frame(json))
		temp2=t(temp2)
		len = length(temp2)
		features = colnames(temp2)
		for(param in params){
			if(!param %in% features){
				temp2<-cbind(temp2,0)
				len=len+1
				colnames(temp2)[len]<-c(param)
			}
		}
		win = temp2[,'wins']
		loses = temp2[,'losses']
		draw = 38-win-loses
		points = win*3+draw*1
		temp2<-cbind(temp2,points)
		len=len+1
		colnames(temp2)[len]<-c('points')
		temp3<-t(as.data.frame(temp2[,c(params,'points')]))
		rownames(temp3)=rownames(temp2)
		data<-rbind(data,temp3)
	}


	return(data)
}


data1 = dataRetrieve(json_file1)
data2 = dataRetrieve(json_file2)
data3 = dataRetrieve(json_file3)
data4 = dataRetrieve(json_file4)
data5 = dataRetrieve(json_file5)
data6 = dataRetrieve(json_file6)
data7 = dataRetrieve(json_file7)

dataFull = data1
dataFull<-rbind(dataFull,data2)
dataFull<-rbind(dataFull,data3)
dataFull<-rbind(dataFull,data4)
dataFull<-rbind(dataFull,data5)
dataTrain<-rbind(dataFull,data6)
dataTest = data7

write.csv(dataFull, file = "data/train.csv")
write.csv(dataTest, file = "data/test.csv")