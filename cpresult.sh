#!/bin/bash
#copy测试结果到目标主机 并将结果导入mongogb
namespace=lmq-test
passwd=Wgl,.2019
srcPath=/root/record.txt
desPath=/root/record.txt
dbName=admin
collectionName=testresult
hostname=47.111.77.29
rm -rf /root/record.txt

for j in `kubectl get pods -n $namespace|awk 'NR>1{print $1}'`
do
   rm -rf /root/resultrecord
   kubectl cp $j:result /root/resultrecord -n $namespace
   for i in `ls /root/resultrecord/down`
   do
     cat /root/resultrecord/down/$i >> ${srcPath}
   done

   for j in `ls /root/resultrecord/up`
   do
     cat /root/resultrecord/up/$j >> ${desPath}
   done

done

/usr/bin/expect <<-EOF
set timeout 5
spawn scp -r ${srcPath} root@${hostname}:${desPath}

set timeout 3
expect {
"yes/no" {send "yes\r";exp_continue}
}
expect "*assword:"
set timeout 3
send "${passwd}\r"
set timeout 300
expect "100%"

spawn ssh root@${hostname}

set timeout 3
expect {
"yes/no" {send "yes\r";exp_continue}
}
expect "*assword:"
set timeout 3
send "${passwd}\r"
set timeout 300

expect "#"
send "mongoimport --db ${dbName} --collection ${collectionName} --file ${desPath}\r"
expect "#"

send "exit\n"
expect eof

EOF
