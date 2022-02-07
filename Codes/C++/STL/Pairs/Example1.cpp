/*
Pair is used to combine together two values that may be different in type. Pair provides a way to store two heterogeneous
 objects as a single unit. It is basically used if we want to store tuples. The pair container is a simple container 
 defined in <utility> header consisting of two data elements or objects. 

The first element is referenced as ‘first’ and the second element as ‘second’ and the order is fixed (first, second).
Pair can be assigned, copied, and compared. The array of objects allocated in a map or hash_map is of type ‘pair’ by 
default in which all the ‘first’ elements are unique keys associated with their ‘second’ value objects.
To access the elements, we use variable name followed by dot operator followed by the keyword first or second.
*/
// CPP program to illustrate Pair in STL
#include <iostream>
#include <utility>
using namespace std;
 
// Driver Code
int main()
{
    // defining a pair
    pair<int, char> PAIR1;
 
    // first part of the pair
    PAIR1.first = 100;
    // second part of the pair
    PAIR1.second = 'G';
 
    cout << PAIR1.first << " ";
    cout << PAIR1.second << endl;
 
    return 0;
}