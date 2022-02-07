/*
Extracting String Parts
There are 3 methods for extracting a part of a string:

slice(start, end)
substring(start, end)
substr(start, length)

substring() is similar to slice().

The difference is that substring() cannot accept negative indexes.

*/

let txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
let length = txt.length;

let str = "Apple, Banana, Kiwi";
let part = str.slice(7, 13);

let str = "Apple, Banana, Kiwi";
let part = str.substring(7, 13);

let str = "Apple, Banana, Kiwi";
let part = str.substr(7, 6);

let text = "Please visit Microsoft!";
let newText = text.replace("Microsoft", "W3Schools");

let text1 = "Hello World!";
let text2 = text1.toUpperCase();

let text1 = "Hello World!";       // String
let text2 = text1.toLowerCase();  // text2 is text1 converted to lower

let text1 = "Hello";
let text2 = "World";
let text3 = text1.concat(" ", text2);

text = "Hello" + " " + "World!";
text = "Hello".concat(" ", "World!");

