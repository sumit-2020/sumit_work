import sys
import csv
sys.stdout = open('memory_data_compact.txt', 'w')
data = list(csv.reader(open('memory_mapping.csv')))

sys.stdout.write('BL1       BL1       0 000 ')

for j in range(1,17):
	for k in range(1,10):
		sys.stdout.write(str(data[j][4*k-3]))
print(' 00000000000000')

sys.stdout.write('BL2       BL2       0 000 ')
for j in range(1,17):
	for k in range(1,10):
		sys.stdout.write(str(data[j][4*k-2]))
print(' 00000000000000')

sys.stdout.write('BL3       BL3       0 000 ')
for j in range(1,17):
	for k in range(1,10):
		sys.stdout.write(str(data[j][4*k-1]))
print(' 00000000000000')

sys.stdout.write('BL4       BL4       0 000 ')
for j in range(1,17):
	for k in range(1,10):
		sys.stdout.write(str(data[j][4*k]))
print(' 00000000000000')

