#There are two types of variables in Python - Local variable and Global variable. Let's understand the following variables.

#Local Variable
#Local variables are the variables that declared inside the function and have scope within the function. 
# Let's understand the following example.

# Declaring a function  
def add():  
    # Defining local variables. They has scope only within a function  
    a = 20  
    b = 30  
    c = a + b  
    print("The sum is:", c)  
  
# Calling a function  
add()  

#Global Variables
#Global variables can be used throughout the program, and its scope is in the entire program. 
# We can use global variables inside or outside the function.

#A variable declared outside the function is the global variable by default. 
# Python provides the global keyword to use global variable inside the function. 
# If we don't use the global keyword, the function treats it as a local variable. Let's understand the following example.

# Declare a variable and initialize it  
x = 101  
  
# Global variable in function  
def mainFunction():  
    # printing a global variable  
    global x  
    print(x)  
    # modifying a global variable  
    x = 'Welcome To Javatpoint'  
    print(x)  
  
mainFunction()  
print(x) 