class MyClass(object):
   pass
# Create first instance of MyClass
this_obj = MyClass()
print(this_obj)
# Another instance of MyClass
that_obj = MyClass()
print (that_obj)

class MyClass(object):
   var = 9

# Create first instance of MyClass
this_obj = MyClass()
print(this_obj.var)

# Another instance of MyClass

that_obj = MyClass()
print (that_obj.var)

class MyClass(object):
   var = 9
   def firstM(self):
      print("hello, World")
obj = MyClass()
print(obj.var)
obj.firstM()


class MyClass(object):
   def firstM(self):
      print("hello, World")
      print(self)
obj = MyClass()
obj.firstM()
print(obj)

#Encapsulation is one of the fundamentals of OOP. OOP enables us to hide the complexity of the internal working of the 
# object which is advantageous to the developer in the following ways −

#Simplifies and makes it easy to understand to use an object without knowing the internals.

#Any change can be easily manageable.

#Object-oriented programming relies heavily on encapsulation. The terms encapsulation and abstraction 
# (also called data hiding) are often used as synonyms. They are nearly synonymous, as abstraction is achieved 
# through encapsulation.

#Encapsulation provides us the mechanism of restricting the access to some of the object’s components, 
# this means that the internal representation of an object can’t be seen from outside of the object definition. 
# Access to this data is typically achieved through special methods − Getters and Setters.

class MyClass(object):
   def setAge(self, num):
      self.age = num

   def getAge(self):
      return self.age

zack = MyClass()
zack.setAge(45)
print(zack.getAge())

zack.setAge("Fourty Five")
print(zack.getAge())

#Init Constructor
#The __init__ method is implicitly called as soon as an object of a class is instantiated.
# This will initialize the object.
class myclass(object):
   def __init__(self,aaa, bbb):
      self.a = aaa
      self.b = bbb

x = myclass(4.5, 3)
print(x.a, x.b)

class InstanceCounter(object):
   count = 0 # class attribute, will be accessible to all instances
   def __init__(self, val):
      self.val = val
      InstanceCounter.count +=1 # Increment the value of class attribute, accessible through class name
# In above line, class ('InstanceCounter') act as an object
   def set_val(self, newval):
      self.val = newval

   def get_val(self):
      return self.val

   def get_count(self):
      return InstanceCounter.count
a = InstanceCounter(9)
b = InstanceCounter(18)
c = InstanceCounter(27)

for obj in (a, b, c):
   print ('val of obj: %s' %(obj.get_val())) # Initialized value ( 9, 18, 27)
   print ('count: %s' %(obj.get_count())) # always 3

