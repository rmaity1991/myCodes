/*Real Life Objects, Properties, and Methods
In real life, a car is an object.

A car has properties like weight and color, and methods like start and stop:


Object Methods
Objects can also have methods.

Methods are actions that can be performed on objects.

Methods are stored in properties as function definitions.

In JavaScript, the this keyword refers to an object.

Which object depends on how this is being invoked (used or called).

The this keyword refers to different objects depending on how it is used:

*/

const car = {type:"Fiat", model:"500", color:"white"};

const person = {
    firstName: "John",
    lastName: "Doe",
    age: 50,
    eyeColor: "blue"
  };


  const person = {
    firstName: "John",
    lastName : "Doe",
    id       : 5566,
    fullName : function() {
      return this.firstName + " " + this.lastName;
    }
  };