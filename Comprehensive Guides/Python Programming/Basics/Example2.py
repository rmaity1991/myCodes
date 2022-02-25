#Variable is a name that is used to refer to memory location. Python variable is also known as an identifier and used to hold value.

#In Python, we don't need to specify the type of variable because Python is a infer language and smart enough to get variable type.

#Variable names can be a group of both the letters and digits, but they have to begin with a letter or an underscore.

#It is recommended to use lowercase letters for the variable name. Rahul and rahul both are two different variables.

a = 50  
b = a  
print(id(a))  
print(id(b))  
# Reassigned variable a  
a = 500  
print(id(a))  

name = "Devansh"  
age = 20  
marks = 80.50  
  
print(name)  
print(age)  
print(marks) 

#The multi-word keywords can be created by the following method.

#Camel Case - In the camel case, each word or abbreviation in the middle of begins with a capital letter. 
# There is no intervention of whitespace. For example - nameOfStudent, valueOfVaraible, etc.

#Pascal Case - It is the same as the Camel Case, but here the first word is also capital. For example - NameOfStudent, etc.

#Snake Case - In the snake case, Words are separated by the underscore. For example - name_of_student, etc.