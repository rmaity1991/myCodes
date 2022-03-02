# A Python program to demonstrate inheritance 
  
# Base or Super class. Note object in bracket.
# (Generally, object is made ancestor of all classes)
# In Python 3.x "class Person" is 
# equivalent to "class Person(object)"
class Person(object):
      
    # Constructor
    def __init__(self, name):
        self.name = name
  
    # To get name
    def getName(self):
        return self.name
  
    # To check if this person is employee
    def isEmployee(self):
        return False
  
  
# Inherited or Sub class (Note Person in bracket)
class Employee(Person):
  
    # Here we return true
    def isEmployee(self):
        return True
  
# Driver code
emp = Person("Geek1")  # An Object of Person
print(emp.getName(), emp.isEmployee())
  
emp = Employee("Geek2") # An Object of Employee
print(emp.getName(), emp.isEmployee())


# Python example to show that base
# class members can be accessed in
# derived class using base class name
class Base(object):
  
    # Constructor
    def __init__(self, x):
        self.x = x    
  
class Derived(Base):
  
    # Constructor
    def __init__(self, x, y):
        Base.x = x 
        self.y = y
  
    def printXY(self):
       
       # print(self.x, self.y) will also work
       print(Base.x, self.y)
  
  
# Driver Code
d = Derived(10, 20)
d.printXY()


# Python example to show that base
# class members can be accessed in
# derived class using super()
class Base(object):
  
    # Constructor
    def __init__(self, x):
        self.x = x    
  
class Derived(Base):
  
    # Constructor
    def __init__(self, x, y):
          
        ''' In Python 3.x, "super().__init__(name)"
            also works''' 
        super(Derived, self).__init__(x)
        self.y = y
  
    def printXY(self):
  
       # Note that Base.x won't work here
       # because super() is used in constructor
       print(self.x, self.y)
  
  
# Driver Code
d = Derived(10, 20)
d.printXY()


# Python program to demonstrate
# use of class method and static method.
from datetime import date
  
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
      
    # a class method to create a Person object by birth year.
    @classmethod
    def fromBirthYear(cls, name, year):
        return cls(name, date.today().year - year)
      
    # a static method to check if a Person is adult or not.
    @staticmethod
    def isAdult(age):
        return age > 18
  
person1 = Person('mayank', 21)
person2 = Person.fromBirthYear('mayank', 1996)
  
print (person1.age)
print (person2.age)
  
# print the result
print (Person.isAdult(22))

