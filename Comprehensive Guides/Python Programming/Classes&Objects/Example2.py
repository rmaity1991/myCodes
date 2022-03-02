#Class Inheritance
#Instead of starting from a scratch, you can create a class by deriving it from a pre-existing class by listing the parent 
#class in parentheses after the new class name.

#The child class inherits the attributes of its parent class, and you can use those attributes as if they were defined in 
# the child class. A child class can also override data members and methods from the parent.

#!/usr/bin/python3

class Parent:        # define parent class
   parentAttr = 100
   def __init__(self):
      print ("Calling parent constructor")

   def parentMethod(self):
      print ('Calling parent method')

   def setAttr(self, attr):
      Parent.parentAttr = attr

   def getAttr(self):
      print ("Parent attribute :", Parent.parentAttr)

class Child(Parent): # define child class
   def __init__(self):
      print ("Calling child constructor")

   def childMethod(self):
      print ('Calling child method')

c = Child()          # instance of child
c.childMethod()      # child calls its method
c.parentMethod()     # calls parent's method
c.setAttr(200)       # again call parent's method
c.getAttr()          # again call parent's method

#Overriding Methods
#You can always override your parent class methods. One reason for overriding parent's methods is that you may want special or 
#different functionality in your subclass.

#!/usr/bin/python3

class Parent:        # define parent class
   def myMethod(self):
      print ('Calling parent method')

class Child(Parent): # define child class
   def myMethod(self):
      print ('Calling child method')

c = Child()          # instance of child
c.myMethod()         # child calls overridden method

#Base Overloading Methods

#__init__ ( self [,args...] )

#Constructor (with any optional arguments)

#Sample Call : obj = className(args)

	
#__del__( self )

#Destructor, deletes an object

#Sample Call : del obj

	
#__repr__( self )

#Evaluatable string representation

#Sample Call : repr(obj)


#__str__( self )

#Printable string representation

#Sample Call : str(obj)

	
#__cmp__ ( self, x )

#Object comparison

#Sample Call : cmp(obj, x)


#Overloading Operators
class Vector:
   def __init__(self, a, b):
      self.a = a
      self.b = b

   def __str__(self):
      return 'Vector (%d, %d)' % (self.a, self.b)
   
   def __add__(self,other):
      return Vector(self.a + other.a, self.b + other.b)

v1 = Vector(2,10)
v2 = Vector(5,-2)
print (v1 + v2)

#Data Hiding
#An object's attributes may or may not be visible outside the class definition. 
# You need to name attributes with a double underscore prefix, and those attributes then will not be directly visible to outsiders.
class JustCounter:
   __secretCount = 0
  
   def count(self):
      self.__secretCount += 1
      print (self.__secretCount)

counter = JustCounter()
counter.count()
counter.count()
print (counter.__secretCount)