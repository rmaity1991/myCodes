"""
Built-in class attributes
Along with the other attributes, a Python class also contains some built-in class attributes which provide information about the class.

The built-in class attributes are given in the below table.

SN	Attribute	Description
1	__dict__	It provides the dictionary containing the information about the class namespace.
2	__doc__	It contains a string which has the class documentation
3	__name__	It is used to access the class name.
4	__module__	It is used to access the module in which, this class is defined.
5	__bases__	It contains a tuple including all base classes.

"""

class Student:    
    def __init__(self,name,id,age):    
        self.name = name;    
        self.id = id;    
        self.age = age    
    def display_details(self):    
        print("Name:%s, ID:%d, age:%d"%(self.name,self.id))    
s = Student("John",101,22)    
print(s.__doc__)    
print(s.__dict__)    
print(s.__module__)    