import numpy as np 
x = np.arange(5) 
print (x)
# dtype set 
x = np.arange(5, dtype = float)
print (x)
# start and stop parameters set 
 
x = np.arange(10,20,2) 
print (x)

#numpy.linspace
#This function is similar to arange() function. 
#In this function, instead of step size, the number of evenly spaced values between the interval is specified. 
x = np.linspace(10,20,5) 
print (x)

# endpoint set to false 
x = np.linspace(10,20, 5, endpoint = False) 
print (x)

#numpy.logspace
#This function returns an ndarray object that contains the numbers that are evenly spaced on a log scale. 
#Start and stop endpoints of the scale are indices of the base, usually 10.
import numpy as np 
# default base is 10 
a = np.logspace(1.0, 2.0, num = 10) 
print (a)

# set base of log space to 2 
import numpy as np 
a = np.logspace(1,10,num = 10, base = 2) 
print (a)

