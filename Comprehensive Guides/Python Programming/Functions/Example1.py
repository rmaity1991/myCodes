#A function is a block of organized, reusable code that is used to perform a single, related action. Functions provide better 
#modularity for your application and a high degree of code reusing.

#As you already know, Python gives you many built-in functions like print(), etc. but you can also create your own functions. 
#These functions are called user-defined functions.

#Defining a Function
#You can define functions to provide the required functionality. Here are simple rules to define a function in Python.

#Function blocks begin with the keyword def followed by the function name and parentheses ( ( ) ).

#Any input parameters or arguments should be placed within these parentheses. You can also define parameters inside these parentheses.

#The first statement of a function can be an optional statement - the documentation string of the function or docstring.

#The code block within every function starts with a colon (:) and is indented.

#The statement return [expression] exits a function, optionally passing back an expression to the caller. A return statement with 
#no arguments is the same as return None.

def printme( str ):
   "This prints a passed string into this function"
   print (str)
   return

# Function definition is here
def printme( str ):
   "This prints a passed string into this function"
   print (str)
   return

# Now you can call printme function
printme("This is first call to the user defined function!")
printme("Again second call to the same function")

# Function definition is here
def changeme( mylist ):
   "This changes a passed list into this function"
   print ("Values inside the function before change: ", mylist)
   
   mylist[2]=50
   print ("Values inside the function after change: ", mylist)
   return

# Now you can call changeme function
mylist = [10,20,30]
changeme( mylist )
print ("Values outside the function: ", mylist)

# Function definition is here
def changeme( mylist ):
   "This changes a passed list into this function"
   mylist = [1,2,3,4] # This would assi new reference in mylist
   print ("Values inside the function: ", mylist)
   return

# Now you can call changeme function
mylist = [10,20,30]
changeme( mylist )
print ("Values outside the function: ", mylist)

# Function definition is here
def printme( str ):
   "This prints a passed string into this function"
   print (str)
   return

# Now you can call printme function
printme()

# Function definition is here
def printme( str ):
   "This prints a passed string into this function"
   print (str)
   return

# Now you can call printme function
printme( str = "My string")

# Function definition is here
def printinfo( name, age ):
   "This prints a passed info into this function"
   print ("Name: ", name)
   print ("Age ", age)
   return

# Now you can call printinfo function
printinfo( age = 50, name = "miki" )

# Function definition is here
def printinfo( name, age = 35 ):
   "This prints a passed info into this function"
   print ("Name: ", name)
   print ("Age ", age)
   return

# Now you can call printinfo function
printinfo( age = 50, name = "miki" )
printinfo( name = "miki" )

# Function definition is here
def printinfo( arg1, *vartuple ):
   "This prints a variable passed arguments"
   print ("Output is: ")
   print (arg1)
   
   for var in vartuple:
      print (var)
   return

# Now you can call printinfo function
printinfo( 10 )
printinfo( 70, 60, 50 )

#The Anonymous Functions
#These functions are called anonymous because they are not declared in the standard manner by using the def keyword. 
#You can use the lambda keyword to create small anonymous functions.

#Lambda forms can take any number of arguments but return just one value in the form of an expression. They cannot contain 
#commands or multiple expressions.

#An anonymous function cannot be a direct call to print because lambda requires an expression.

#Lambda functions have their own local namespace and cannot access variables other than those in their parameter list and 
#those in the global namespace.

#Although it appears that lambdas are a one-line version of a function, they are not equivalent to inline statements in 
#C or C++, whose purpose is to stack allocation by passing function, during invocation for performance reasons.

# Function definition is here
sum = lambda arg1, arg2: arg1 + arg2

# Now you can call sum as a function
print ("Value of total : ", sum( 10, 20 ))
print ("Value of total : ", sum( 20, 20 ))

# Function definition is here
def sum( arg1, arg2 ):
   # Add both the parameters and return them."
   total = arg1 + arg2
   print ("Inside the function : ", total)
   return total

# Now you can call sum function
total = sum( 10, 20 )
print ("Outside the function : ", total )

total = 0   # This is global variable.
# Function definition is here
def sum( arg1, arg2 ):
   # Add both the parameters and return them."
   total = arg1 + arg2; # Here total is local variable.
   print ("Inside the function local total : ", total)
   return total

# Now you can call sum function
sum( 10, 20 )
print ("Outside the function global total : ", total )

