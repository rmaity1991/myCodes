#Python has been an object-oriented language since the time it existed. Due to this, creating and using classes and objects are 
#downright easy. This chapter helps you become an expert in using Python's object-oriented programming support.
#Overview of OOP Terminology
#Class − A user-defined prototype for an object that defines a set of attributes that characterize any object of the class. 
# The attributes are data members (class variables and instance variables) and methods, accessed via dot notation.

#Class variable − A variable that is shared by all instances of a class. Class variables are defined within a class but outside 
# any of the class's methods. Class variables are not used as frequently as instance variables are.

#Data member − A class variable or instance variable that holds data associated with a class and its objects.

#Function overloading − The assignment of more than one behavior to a particular function. The operation performed varies by the 
# types of objects or arguments involved.

#Instance variable − A variable that is defined inside a method and belongs only to the current instance of a class.

#Inheritance − The transfer of the characteristics of a class to other classes that are derived from it.

#Instance − An individual object of a certain class. An object obj that belongs to a class Circle, for example, is an instance of 
# the class Circle.

#Instantiation − The creation of an instance of a class.

#Method − A special kind of function that is defined in a class definition.

#Object − A unique instance of a data structure that is defined by its class. An object comprises both data members 
# (class variables and instance variables) and methods.

#Operator overloading − The assignment of more than one function to a particular operator.

class Employee:
   'Common base class for all employees'
   empCount = 0
#The first method __init__() is a special method, which is called class constructor or initialization method that 
#Python calls when you create a new instance of this class.
   def __init__(self, name, salary):
      self.name = name
      self.salary = salary
      Employee.empCount += 1
   
   def displayCount(self):
     print ("Total Employee %d" % Employee.empCount)

   def displayEmployee(self):
      print ("Name : ", self.name,  ", Salary: ", self.salary)

#This would create first object of Employee class
emp1 = Employee("Zara", 2000)
#This would create second object of Employee class
emp2 = Employee("Manni", 5000)

emp1.displayEmployee()
emp2.displayEmployee()
print ("Total Employee %d" % Employee.empCount)

hasattr(emp1, 'salary')    # Returns true if 'salary' attribute exists
getattr(emp1, 'salary')    # Returns value of 'salary' attribute
setattr(emp1, 'salary', 7000) # Set attribute 'salary' at 7000
delattr(emp1, 'salary')    # Delete attribute 'salary'

#Built-In Class Attributes
#Every Python class keeps following built-in attributes and they can be accessed using dot operator like any other attribute −

#__dict__ − Dictionary containing the class's namespace.

#__doc__ − Class documentation string or none, if undefined.

#__name__ − Class name.

#__module__ − Module name in which the class is defined. This attribute is "__main__" in interactive mode.

#__bases__ − A possibly empty tuple containing the base classes, in the order of their occurrence in the base class list.

print ("Employee.__doc__:", Employee.__doc__)
print ("Employee.__name__:", Employee.__name__)
print ("Employee.__module__:", Employee.__module__)
print ("Employee.__bases__:", Employee.__bases__)
print ("Employee.__dict__:", Employee.__dict__ )

a = 40      # Create object <40>
b = a       # Increase ref. count  of <40> 
c = [b]     # Increase ref. count  of <40> 

del a       # Decrease ref. count  of <40>
b = 100     # Decrease ref. count  of <40> 
c[0] = -1   # Decrease ref. count  of <40> 

#!/usr/bin/python3

class Point:
   def __init__( self, x=0, y=0):
      self.x = x
      self.y = y
   def __del__(self):
      class_name = self.__class__.__name__
      print (class_name, "destroyed")

pt1 = Point()
pt2 = pt1
pt3 = pt1
print (id(pt1), id(pt2), id(pt3))   # prints the ids of the obejcts
del pt1
del pt2
del pt3