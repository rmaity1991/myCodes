/*
Properties are named members of classes, structures, and interfaces. Member variables or methods in a class or 
structures are called Fields. Properties are an extension of fields and are accessed using the same syntax. They 
use accessors through which the values of the private fields can be read, written or manipulated.

Properties do not name the storage locations. Instead, they have accessors that read, write, or compute their values.
*/
using System;
// Declare a Code property of type string:
public string Code {
   get {
      return code;
   }
   set {
      code = value;
   }
}

// Declare a Name property of type string:
public string Name {
   get {
      return name;
   }
   set {
      name = value;
   }
}

// Declare a Age property of type int:
public int Age { 
   get {
      return age;
   }
   set {
      age = value;
   }
}