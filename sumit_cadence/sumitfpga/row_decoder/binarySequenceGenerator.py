import sys
for j in range(0,7):
    sys.stdout.write('Config'+str(7-j)+'    config'+str(7-j)+'    0 0000')
    for i in range(1,2**(6-j)+1):
        sys.stdout.write('0'*(2**j))
        sys.stdout.flush()
        sys.stdout.write('1'*(2**j))
        sys.stdout.flush()
    sys.stdout.write('\n')
    sys.stdout.flush()
    sys.stdout.write('Config_'+str(7-j)+'   config_'+str(7-j)+'   0 1111')
    for i in range(1,2**(6-j)+1):
        sys.stdout.write('1'*(2**j))
        sys.stdout.flush()
        sys.stdout.write('0'*(2**j))
        sys.stdout.flush()
    sys.stdout.write('\n')
    sys.stdout.flush()
