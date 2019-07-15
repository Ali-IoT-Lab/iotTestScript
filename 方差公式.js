var sum = function(x,y){ return x+y;};　　//求和函数
var square = function(x){ return x*x;};　　//数组中每个元素求它的平方

var data = [1,1,3,5,5];　　//
var mean = data.reduce(sum)/data.length;
var deviations = data.map(function(x){return x-mean;});
var stddev = Math.sqrt(deviations.map(square).reduce(sum)/(data.length-1));
var stddev1 = deviations.map(square).reduce(sum)/(data.length-1);

console.log("平均值："+mean);
console.log("偏差："+deviations);
console.log("标准差："+stddev.toFixed(2))
console.log("平方差："+stddev1.toFixed(2))

4+4+0+4+4