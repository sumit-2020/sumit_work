import sys
for j in range(0,5):
    sys.stdout.write('A'+str(j)+'    A'+str(j)+'    0 0000')
    for i in range(1,2**(4-j)+1):
        sys.stdout.write('0'*(2**j))
        sys.stdout.flush()
        sys.stdout.write('1'*(2**j))
        sys.stdout.flush()
    sys.stdout.write('\n')
    sys.stdout.flush()
