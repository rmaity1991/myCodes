#Each key is separated from its value by a colon (:), the items are separated by commas, and the whole thing is enclosed in curly 
#braces. An empty dictionary without any items is written with just two curly braces, like this: {}.

#Keys are unique within a dictionary while values may not be. The values of a dictionary can be of any type, but the keys must be 
#of an immutable data type such as strings, numbers, or tuples.

#!/usr/bin/python3

dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'}
print ("dict['Name']: ", dict['Name'])
print ("dict['Age']: ", dict['Age'])

dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'};
print ("dict['Alice']: ", dict['Alice'])

dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'}
dict['Age'] = 8; # update existing entry
dict['School'] = "DPS School" # Add new entry

print ("dict['Age']: ", dict['Age'])
print ("dict['School']: ", dict['School'])

dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'}

del dict['Name'] # remove entry with key 'Name'
dict.clear()     # remove all entries in dict
del dict         # delete entire dictionary

print ("dict['Age']: ", dict['Age'])
print ("dict['School']: ", dict['School'])

dict1 = {'Name': 'Zara', 'Age': 7};
dict2 = {'Name': 'Mahnaz', 'Age': 27};
dict3 = {'Name': 'Abid', 'Age': 27};
dict4 = {'Name': 'Zara', 'Age': 7};
print ("Return Value : %d" %  dict.cmp (dict1, dict2))
print ("Return Value : %d" %  dict.cmp (dict2, dict3))
print ("Return Value : %d" %  dict.cmp (dict1, dict4))


dict = {'Name': 'Manni', 'Age': 7, 'Class': 'First'}
print ("Length : %d" % len (dict))

dict = {'Name': 'Manni', 'Age': 7, 'Class': 'First'}
print ("Equivalent String : %s" % dict.str (dict))

dict = {'Name': 'Zara', 'Age': 7}
print ("Start Len : %d" %  len(dict))

dict.clear()
print ("End Len : %d" %  len(dict))

dict1 = {'Name': 'Manni', 'Age': 7, 'Class': 'First'}
dict2 = dict1.copy()
print ("New Dictionary : ",dict2)


seq = ('name', 'age', 'sex')

dict = dict.fromkeys(seq)
print ("New Dictionary : %s" %  dict.str(dict))

dict = dict.fromkeys(seq, 10)
print ("New Dictionary : %s" %  dict.str(dict))

dict = {'Name': 'Zara', 'Age': 27}

print ("Value : %s" %  dict.get('Age'))
print ("Value : %s" %  dict.get('Sex', "NA"))

dict = {'Name': 'Zara', 'Age': 7}

print ("Age" in dict)

print ("Sex" in dict)

dict = {'Name': 'Zara', 'Age': 7}
print ("Value : %s" %  dict.items())
dict = {'Name': 'Zara', 'Age': 7}
print ("Value : %s" %  dict.keys())
dict = {'Sex': 'female', 'Age': 7, 'Name': 'Zara'}
print ("Values : ",  list(dict.values()))

dict = {'Name': 'Zara', 'Age': 7}
dict2 = {'Sex': 'female' }

dict.update(dict2)
print ("updated dict : ", dict)


