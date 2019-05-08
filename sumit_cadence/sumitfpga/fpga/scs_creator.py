import sys
import fileinput
orig_stdout = sys.stdout
sys.stdout = open('stimulus.scs', 'w')
TIM=147
print('simulator lang=spectre') 
print('parameters VDD = 1.8')
print('//tr is (transition time)/2')
print('parameters tr = 1n') 
print('//f is the fall time') 
print('//parameters f = 100p')
print('//K is the signal period for programming') 
print('parameters K = 5u') 
print('//L is the signal period for running') 
print('parameters L = 0.5u')
print('\n')
print('vVdd (vdd 0) vsource dc=VDD')
print('vGnd (gnd 0) vsource dc=0')
print('\n')

lines = [line.rstrip('\n') for line in open('memory_data_compact.txt','r')]

while '' in lines:
    lines.remove('')

for line in lines:
	words=line.split()
	print('v'+words[0]+' ('+words[1]+ ' '+words[2]+') vsource type=pwl wave=\[')
	sent=words[3:]
	sen=''.join(sent)
	sen=sen.replace(" ", "")
	bits=list(sen)
	for i in range(len(bits)):
		ostr=""
		ostr+="+ ("
		if i==0:
			ostr+=" 0*K   ) "
		else:
			if i<TIM:
				ostr+=str(i).rjust(2)+'*K+tr) '
			else:
				ostr+=str(TIM).rjust(2)+'*K+'+str(i-TIM).rjust(2)+'*L+tr) '
		if bits[i]=='0':
			if i<TIM:
				ostr+='0    ('+str(i+1).rjust(2)+'*K-tr) 0'
			else:
				ostr+='0    ('+str(TIM).rjust(2)+'*K+'+str(i-TIM+1).rjust(2)+'*L-tr) 0'
		if bits[i]=='1':
			if i<TIM:
				ostr+='VDD  ('+str(i+1).rjust(2)+'*K-tr) VDD'
			else:
				ostr+='VDD  ('+str(TIM).rjust(2)+'*K+'+str(i-TIM+1).rjust(2)+'*L-tr) VDD'
		print(ostr)
	print('+ ]')

	if words[0][0]=='B' and words[0][1]=='L':
		print('vBL_'+words[0][2:]+' (BL_'+words[1][2:]+ ' '+words[2]+') vsource type=pwl wave=\[')
		sent=words[3:]
		sen=''.join(sent)
		sen=sen.replace(" ", "")
		bits=list(sen)
		for i in range(len(bits)):
			ostr=""
			ostr+="+ ("
			if i==0:
				ostr+=" 0*K   ) "
			else:
				if i<TIM:
					ostr+=str(i).rjust(2)+'*K+tr) '
				else:
					ostr+=str(TIM).rjust(2)+'*K+'+str(i-TIM).rjust(2)+'*L+tr) '
			if bits[i]=='0':
				if i<TIM:
					ostr+='VDD  ('+str(i+1).rjust(2)+'*K-tr) VDD'
				else:
					ostr+='VDD  ('+str(TIM).rjust(2)+'*K+'+str(i-TIM+1).rjust(2)+'*L-tr) VDD'
			if bits[i]=='1':
				if i<TIM:
					ostr+='0    ('+str(i+1).rjust(2)+'*K-tr) 0'
				else:
					ostr+='0    ('+str(TIM).rjust(2)+'*K+'+str(i-TIM+1).rjust(2)+'*L-tr) 0'
			print(ostr)
		print('+ ]')
		
sys.stdout.close()
sys.stdout=orig_stdout 
# Read in the file
with open('stimulus.scs', 'r') as file :
  filedata = file.read()

# Replace the target string
filedata = filedata.replace('BL', 'BitLine')

# Write the file out again
with open('stimulus.scs', 'w') as file:
  file.write(filedata)
		
		
			
			
	
