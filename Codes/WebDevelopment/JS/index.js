// 1. Ways to print in Java Script
console.log("Hello World");
console.error("This is an error");
alert("Hello World");
document.write("This is new document");
// 2. Variables in Java Script

var num1=23;
var num2=34;
console.log(num1+num2);
/*
this is
a multiline comment
*/

// 3. Datatypes in JS

var str="Rohit Maity";
var float1=34.56;

var int1=45;

var b=true;


//Objects

var marks={
    ravi: 34,
    shubham:34,
    rohit:50,
    romela:45
}

console.log(marks);

var undef=undefined;
var undef1;

/*
At high level there are 2 types of variable sin JS,
1) Primitive Data Types = undefined, null, int, float, boolean, double, string
2) Reference Data Types = Arrays & Objects
*/

var arr1=[1,2,3,4,5,6,7,8,9];

console.log(arr1);

// 4. Arithmetic Operation and Logical
var var1=23;
var var2=34;
console.log("The addition is :",var1+var2);
console.log("The substraction is :",var1-var2);
console.log("The multiplication is :",var1*var2);
console.log("The division is :",var1/var2);
console.log("The modulus is :",var1%var2);

console.log(var1 && var2);
console.log(var1 || var2);
console.log(!var1);

console.log(var1 == var2);
console.log(var1 <= var2);
console.log(var1 >= var2);
console.log(var1 < var2);
console.log(var1 > var2);
console.log(var1 != var2);
// 5. Functions in JS

function add(a, b){
    return a+b;
}
function avg(a,b){
    var c=(a+b)/2;
    return c;
}

console.log(add(23,34));
console.log(avg(23,34));

// 6. Conditionals in JS
var age =34;
if(age>18){
    console.log("You can Drink");
}
else{
    console.log("You go drink water");
}

if( age>18){
    console.log("You can Drink");
}

if(age<12){
    console.log("Bournvita");
}
else if( age >18){
    console.log("Drinks Cheers");
}
else{
    console.log("Nothing");
}


// 7. Loop statements in JS

var arr2=[1,2,3,4,5,6,7,8,9,0];

for(i=0;i<arr2.length;i++){
    console.log(arr2[i]);
}

arr2.forEach(function(element){
    console.log(element);
})

while(i<arr2.length){
    console.log(arr2[i]);
}

do{
    console.log(arr2[i])
}while(i<arr2.length);

// 8. Break and Continue Statements

for(i=0;i<arr2.length;i++){
    if(i==2){
        break;
    }
    console.log(arr2[i]);
}

for(i=0;i<arr2.length;i++){
    if(i<5){
        continue;
    }
    console.log(arr2[i]);
}

// 9. Array Methods

var arr3=[23,45,54,67,23,45];

console.log(arr3.length);

arr3.push(456);
console.log(arr3);
console.log(arr3.length);

arr3.pop();
console.log(arr3);
arr3.shift();
console.log(arr3);
arr3.unshift(100);
console.log(arr3);
arr3.toString();
arr3.sort();

// 10. String Methods in JavaScript

var str1="This is a string which will be formatted as per string methods";

console.log(str1.length);
console.log(str1.indexOf("string"));
console.log(str1.slice(0,5));
console.log(str1.lastIndexOf("whi"));
console.log(str1.replace("This","That"));
console.log(str1);


// 11. Manipulating dates
var d= new Date();

console.log(d);
console.log(d.getTime());
console.log(d.getFullYear());
console.log(d.getDay());
console.log(d.getMonth());