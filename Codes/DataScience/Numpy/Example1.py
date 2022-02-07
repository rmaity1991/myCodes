import numpy as np 
a = np.array([1,2,3]) 
print (a)

a = np.array([[1, 2], [3, 4]]) 
print (a)

a = np.array([1, 2, 3,4,5], ndmin = 2) 
print (a)

a = np.array([1, 2, 3], dtype = complex) 
print (a)


a = np.array([[1,2,3],[4,5,6]]) 
print (a.shape)
a = np.array([[1,2,3],[4,5,6]]) 
a.shape = (3,2) 
print (a) 

a = np.array([[1,2,3],[4,5,6]]) 
b = a.reshape(3,2) 
print (b)
a = np.arange(24) 
print (a)

a = np.arange(24) 
print(a.ndim)

# now reshape it 
b = a.reshape(2,4,3) 
print (b) 
# b is having three dimensions

x = np.array([1,2,3,4,5], dtype = np.int8) 
print (x.itemsize)
