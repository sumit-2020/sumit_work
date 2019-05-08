lines = [line.rstrip('\n') for line in open('scs_creator_input.txt','r')]
for line in lines:
	words=line.split()
	print('v'+words[0]+' ('+words[1]+ ' '+words[2]+') vsource type=pwl wave=\[')
	bits=list(words[3])
	for i in range(len(bits)):
		ostr=""
		ostr+="+ ("
		if i==0:
			ostr+=" 0*K   ) "
		else:
			ostr+=str(i).rjust(2)+'*K+tr) '
		if bits[i]=='0':
			ostr+='0    ('+str(i+1).rjust(2)+'*K-tr) 0'
		if bits[i]=='1':
			ostr+='VDD  ('+str(i+1).rjust(2)+'*K-tr) VDD'
		print(ostr)
	print('+ ]')
		
			
			
	
