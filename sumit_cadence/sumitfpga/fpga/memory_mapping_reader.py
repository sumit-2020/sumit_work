import sys
import csv
sys.stdout = open('memory_data.txt', 'w')
data = list(csv.reader(open('memory_mapping2.csv')))
for i in range(1,75):
	sys.stdout.write(str('WL'+str(i)).ljust(4)+'      '+str('WL'+str(i)).ljust(4)+'      0 000 ')
	for j in range(1,75):
		sys.stdout.write(str(1 if i==j else 0))
	print(' 00000000000000')
for i in range(1,109):
	sys.stdout.write(str('BL'+str(i)).ljust(5)+'     '+str('BL'+str(i)).ljust(5)+'     0 000 ')
	for j in range(1,75):
		sys.stdout.write(str(data[j][i]))
	print(' 00000000000000')


