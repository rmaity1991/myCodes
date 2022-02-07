# convert list to ndarray 
import numpy as np 

x = [1,2,3] 
a = np.asarray(x) 
print (a)

x = [1,2,3]
a = np.asarray(x, dtype = float) 
print (a)

x = (1,2,3) 
a = np.asarray(x) 
print (a)
# ndarray from list of tuples 
x = [(1,2,3),(4,5)] 
a = np.asarray(x) 
print (a)


s = 'Hello World' 
a = np.frombuffer(s, dtype = 'S1') 
print (a)