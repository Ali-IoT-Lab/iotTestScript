#/bin/bash


forkNum=100
namespace=node-kube-apps

for j in `kubectl get pods -n $namespace|awk 'NR>1{print $1}'`
do

rm -rf tmp1.js
rm -rf tmp2.js
echo > clientId.js

for ((i=1;i<=$forkNum;i++))
do
  ((sum = sum + i))
  if [ $i = 1 ]; then
    echo -n "\"$i\": \"" >> tmp1.js
    
    echo `date`$sum|md5sum|awk '{print $1}' >> tmp1.js
  elif [ $i = $forkNum ]; then 
    echo -n "\"$i\": \"" >> tmp1.js
    echo `date`$sum|md5sum|awk '{print $1}'>> tmp1.js
  else
    echo -n "\"$i\": \"" >> tmp1.js   
    echo `date`$sum|md5sum|awk '{print $1}' >> tmp1.js
  fi
done

sed 's/$/",/' tmp1.js >> tmp2.js
echo "module.exports = {" >> clientId.js
cat tmp2.js >> clientId.js
echo "}" >> clientId.js
rm -rf tmp1.js
rm -rf tmp2.js

echo $j

kubectl cp /root/clientId.js $j:/home/Service -n $namespace

#error=$?
#if [ $error ] ; then
#
# echo $error
# continue
#fi

done
