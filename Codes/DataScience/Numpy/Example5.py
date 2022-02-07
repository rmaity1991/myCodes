#Contents of ndarray object can be accessed and modified by indexing or slicing, just like Python's in-built container 
# objects.

#As mentioned earlier, items in ndarray object follows zero-based index. Three types of indexing methods are available 
# − field access, basic slicing and advanced indexing.

#Basic slicing is an extension of Python's basic concept of slicing to n dimensions. A Python slice object is constructed
#by giving start, stop, and step parameters to the built-in slice function. This slice object is passed to the array to 
#a part of array.

import numpy as np 
a = np.arange(10) 
s = slice(2,7,2) 
print (a[s])
a = np.arange(10) 
b = a[2:7:2] 
print (b)
# slice items starting from index 
import numpy as np 
a = np.arange(10) 
print (a[2:])
import numpy as np 
a = np.array([[1,2,3],[3,4,5],[4,5,6]]) 
print (a)

# slice items starting from index
print ('Now we will slice the array from the index a[1:]') 
print (a[1:])

# array to begin with 
import numpy as np 
a = np.array([[1,2,3],[3,4,5],[4,5,6]]) 

print ('Our array is:' )
print (a )
print ('\n' ) 

# this returns array of items in the second column 
print ('The items in the second column are:')  
print (a[...,1] )
print ('\n' ) 

# Now we will slice all items from the second row 
print ('The items in the second row are:' )
print (a[1,...] )
print ('\n' ) 

# Now we will slice all items from column 1 onwards 
print ('The items column 1 onwards are:' )
print (a[...,1:])