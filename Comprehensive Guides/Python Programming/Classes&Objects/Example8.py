class Student:    
    count = 0    
    def __init__(self):    
        Student.count = Student.count + 1    
s1=Student()    
s2=Student()    
s3=Student()    
print("The number of students:",Student.count) 


class Student:  
    # Constructor - non parameterized  
    def __init__(self):  
        print("This is non parametrized constructor")  
    def show(self,name):  
        print("Hello",name)  
student = Student()  
student.show("John")     

class Student:  
    # Constructor - parameterized  
    def __init__(self, name):  
        print("This is parametrized constructor")  
        self.name = name  
    def show(self):  
        print("Hello",self.name)  
student = Student("John")  
student.show()    


class Student:  
    roll_num = 101  
    name = "Joseph"  
  
    def display(self):  
        print(self.roll_num,self.name)  
  
st = Student()  
st.display()  


class Student:  
    def __init__(self):  
        print("The First Constructor")  
    def __init__(self):  
        print("The second contructor")  
  
st = Student()  