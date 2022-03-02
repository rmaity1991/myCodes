#Inheritance
#One of the major advantages of Object Oriented Programming is re-use. Inheritance is one of the mechanisms to 
# achieve the same. Inheritance allows programmer to create a general or a base class first and then later extend 
# it to more specialized class. It allows programmer to write better code.

#Using inheritance you can use or inherit all the data fields and methods available in your base class. 
# Later you can add you own methods and data fields, thus inheritance provides a way to organize code, 
# rather than rewriting it from scratch.

class Thought(object):
   def __init__(self):
      pass
   def message(self):
      print("Thought, always come and go")

class Advice(Thought):
   def __init__(self):
      super(Advice, self).__init__()
   def message(self):
      print('Warning: Risk is always involved when you are dealing with market!')


