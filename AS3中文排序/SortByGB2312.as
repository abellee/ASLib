package 
{
import flash.utils.ByteArray;
 
public class SortByGB2312
{
public function SortByGB2312() {
throw new Error("There is an unexpected error!");
}
public static function sort(arr:Array):Array {
arr.sort();
var byte:ByteArray = new ByteArray();
var sortedArr:Array = [];
var returnArr:Array = [];
for (var m:int = 0; m < arr.length; m++ ) {
var str:String = arr[m];
if (str.charCodeAt(0) < 123) {
returnArr[returnArr.length] = str;
arr[m] = null;
continue;
}
byte.writeMultiByte(str.charAt(0), "gb2312");
}
for (var n:int = 0; n < arr.length; n++ ) {
if (String(arr[n]) == "null") {
arr.splice(n, 1);
n--;
continue;
}
}
byte.position = 0;
var len:int = byte.length / 2;
for (var i:int = 0; i < len; i++ ) {
sortedArr[sortedArr.length] = { a:byte[i * 2], b:byte[i * 2 + 1], c:arr[i] };
}
sortedArr.sortOn(["a", "b"], [Array.DESCENDING | Array.NUMERIC]);
for each(var obj:Object in sortedArr) {
returnArr[returnArr.length] = obj.c;
}
byte.clear();
return returnArr;
}
}
}