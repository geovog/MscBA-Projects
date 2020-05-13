import time
import os
import textwrap
import re

#operations timer
start_time = time.time()
output_file = open('output.csv','w',encoding="utf8")
output_file.write("DATETIME"+"\t"+"USER"+"\t"+"TWEET"+'\n')

#create a stage file where we form the rows by detecting '\n' character,looping on the row data file line by line
with open("C:\\Users\\George\\Desktop\\tweets\\tweets2009-07.txt", "r",encoding="utf8") as infile: 
	for line in infile:
		if line[0]=='T':
			output_file.write(line[2:-1]+'\t')
		elif line[0]=='U':
			line = line.split('/')[-1]
			line = line[:-1]
			output_file.write(line+'\t')
		elif line[0]=='W':
			output_file.write(line[2:-1]+'\n')
	
output_file.close()	

#create stage files where we split our lines selecting only these between 1-5 july
output_csv1 = open('out1.csv','w',encoding="utf8")
output_csv1.write("DATETIME"+"\t"+"USER"+"\t"+"TWEET"+'\n')
output_csv2 = open('out2.csv','w',encoding="utf8")
output_csv2.write("DATETIME"+"\t"+"USER"+"\t"+"TWEET"+'\n')
output_csv3 = open('out3.csv','w',encoding="utf8")
output_csv3.write("DATETIME"+"\t"+"USER"+"\t"+"TWEET"+'\n')
output_csv4 = open('out4.csv','w',encoding="utf8")
output_csv4.write("DATETIME"+"\t"+"USER"+"\t"+"TWEET"+'\n')
output_csv5 = open('out5.csv','w',encoding="utf8")
output_csv5.write("DATETIME"+"\t"+"USER"+"\t"+"TWEET"+'\n')

with open("output.csv", "r",encoding="utf8") as infile2: 
	for line in infile2:
		if ('2009-07-01 ' in line[0:20]):
			output_csv1.write(line)
		elif ('2009-07-02 ' in line[0:20]):
			output_csv2.write(line)
		elif ('2009-07-03 ' in line[0:20]):
			output_csv3.write(line)
		elif ('2009-07-04 ' in line[0:20]):
			output_csv4.write(line)
		elif ('2009-07-05 ' in line[0:20]):
			output_csv5.write(line)	

output_csv1.close()	
output_csv2.close()
output_csv3.close()	
output_csv4.close()	
output_csv5.close()

csv1 = open('outf1.csv','w',encoding="utf8")
csv1.write("dt"+"\t"+"user"+"\t"+"mention"+'\n')
csv2 = open('outf2.csv','w',encoding="utf8")
csv2.write("dt"+"\t"+"user"+"\t"+"mention"+'\n')
csv3 = open('outf3.csv','w',encoding="utf8")
csv3.write("dt"+"\t"+"user"+"\t"+"mention"+'\n')
csv4 = open('outf4.csv','w',encoding="utf8")
csv4.write("dt"+"\t"+"user"+"\t"+"mention"+'\n')
csv5 = open('outf5.csv','w',encoding="utf8")
csv5.write("dt"+"\t"+"user"+"\t"+"mention"+'\n')

#find mentions and rewrite the whole line if there is more than one mention
with open("out1.csv", "r+",encoding="utf8") as file1: 
	for line in file1:
		test = re.findall(r'[@]\w+', line)
		for i in test: 
			if (len(test)>0):
				a,b,c = line.split('\t')
				line = a+'\t'+b+'\t'+i[1:]+'\n'
				csv1.write(line)
				
with open("out2.csv", "r+",encoding="utf8") as file2: 
	for line in file2:
		test = re.findall(r'[@]\w+', line)
		for i in test: 
			if (len(test)>0):
				a,b,c = line.split('\t')
				line = a+'\t'+b+'\t'+i[1:]+'\n'
				csv2.write(line)

with open("out3.csv", "r+",encoding="utf8") as file3: 
	for line in file3:
		test = re.findall(r'[@]\w+', line)
		for i in test: 
			if (len(test)>0):
				a,b,c = line.split('\t')
				line = a+'\t'+b+'\t'+i[1:]+'\n'
				csv3.write(line)

with open("out4.csv", "r+",encoding="utf8") as file4: 
	for line in file4:
		test = re.findall(r'[@]\w+', line)
		for i in test: 
			if (len(test)>0):
				a,b,c = line.split('\t')
				line = a+'\t'+b+'\t'+i[1:]+'\n'
				csv4.write(line)

with open("out5.csv", "r+",encoding="utf8") as file5: 
	for line in file5:
		test = re.findall(r'[@]\w+', line)
		for i in test: 
			if (len(test)>0):
				a,b,c = line.split('\t')
				line = a+'\t'+b+'\t'+i[1:]+'\n'
				csv5.write(line)

csv1.close()				
csv2.close()
csv3.close()
csv4.close()
csv5.close()



#remove unwanted files	
if os.path.exists("output.csv"):
	os.remove("output.csv")
else:
  print("The file does not exist")	
  
if os.path.exists("out1.csv"):
	os.remove("out1.csv")
else:
  print("The file does not exist")
  
if os.path.exists("out2.csv"):
	os.remove("out2.csv")
else:
  print("The file does not exist")
  
if os.path.exists("out3.csv"):
	os.remove("out3.csv")
else:
  print("The file does not exist")
  
if os.path.exists("out4.csv"):
	os.remove("out4.csv")
else:
  print("The file does not exist")
  
if os.path.exists("out5.csv"):
	os.remove("out5.csv")
else:
  print("The file does not exist")
  
#end of timer			
elapsed_time = time.time() - start_time	
print ("Elapsed Time: "+str(elapsed_time)+" "+"seconds")		