# https://tmfujis.wordpress.com/2014/10/20/sampling-from-a-huge-data-file/

import sys
import random
 
def reservoir_sample(stream, n):
    res = []
 
    for i, el in enumerate(stream):
        if i <= n:
            res.append(el)
        else:
            rand = random.sample(xrange(i), 1)[0]
            if rand < n:
                res[random.sample(xrange(n), 1)[0]] = el
    return res
 
if __name__=="__main__":
    samp = reservoir_sample(sys.stdin, 500000)
    for s in samp:
        sys.stdout.write(s)
