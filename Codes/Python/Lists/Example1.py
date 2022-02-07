#The most basic data structure in Python is the sequence. Each element of a sequence is assigned a number - its position or index. 
#The first index is zero, the second index is one, and so forth.

#Python has six built-in types of sequences, but the most common ones are lists and tuples, which we would see in this tutorial.

#Python Lists
#The list is the most versatile datatype available in Python, which can be written as a list of comma-separated values (items) 
#between square brackets

#Python Lists
#The list is the most versatile datatype available in Python, which can be written as a list of comma-separated values (items) between 
#square brackets

list1 = ['physics', 'chemistry', 1997, 2000];
list2 = [1, 2, 3, 4, 5 ];
list3 = ["a", "b", "c", "d"];

#Accessing Values in Lists
#To access values in lists, use the square brackets for slicing along with the index or indices to obtain value available at that 
#index.

#!/usr/bin/python3

list1 = ['physics', 'chemistry', 1997, 2000]
list2 = [1, 2, 3, 4, 5, 6, 7 ]

print ("list1[0]: ", list1[0])
print ("list2[1:5]: ", list2[1:5])

#Updating Lists
#You can update single or multiple elements of lists by giving the slice on the left-hand side of the assignment operator, and you can 
#add to elements in a list with the append() method.
#!/usr/bin/python3

list = ['physics', 'chemistry', 1997, 2000]
print ("Value available at index 2 : ", list[2])

list[2] = 2001
print ("New value available at index 2 : ", list[2])

#Delete List Elements
#To remove a list element, you can use either the del statement if you know exactly which element(s) you are deleting. You can use the 
#remove() method if you do not know exactly which items to delete.
#!/usr/bin/python3

list = ['physics', 'chemistry', 1997, 2000]
print (list)

del list[2]
print ("After deleting value at index 2 : ", list)

print(len(list));
print(max(list));
print(min(list));

tuple1=(1,2,3,4,5,6,6,7,9)
list1=list(tuple1);

list1 = ['C++', 'Java', 'Python']
list1.append('C#')
print ("updated list : ", list1)

aList = [123, 'xyz', 'zara', 'abc', 123];

print ("Count for 123 : ", aList.count(123))
print ("Count for zara : ", aList.count('zara'))

list1 = ['physics', 'chemistry', 'maths']
list2 = list(range(5))     #creates list of numbers between 0-4
list1.extend(list2)
print ('Extended List :', list1)

list1 = ['physics', 'chemistry', 'maths']
print ('Index of chemistry', list1.index('chemistry'))
print ('Index of C#', list1.index('C#'))

#!/usr/bin/python3

list1 = ['physics', 'chemistry', 'maths']
list1.insert(1, 'Biology')
print ('Final list : ', list1)

list1 = ['physics', 'Biology', 'chemistry', 'maths']
list1.pop()
print ("list now : ", list1)

list1.pop(1)
print ("list now : ", list1)

list1 = ['physics', 'Biology', 'chemistry', 'maths']
list1.remove('Biology')
print ("list now : ", list1)
list1.remove('maths')
print ("list now : ", list1)

list1 = ['physics', 'Biology', 'chemistry', 'maths']
list1.reverse()
print ("list now : ", list1)

list1 = ['physics', 'Biology', 'chemistry', 'maths']
list1.sort()
print ("list now : ", list1)

# This concludes the list tutorials
