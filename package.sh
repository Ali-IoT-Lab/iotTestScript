#!/bin/bash

cd $1

docker build -t mangseng/nodeappk8s:v$2 .

/usr/bin/expect <<-EOF

set timeout 5

spawn docker login


expect {
    "Username:" {send "mangseng\r"}
    "Password:" {send "Wgl,.2019\r"}
    eof {send_tty "eof, will exit.\n";exit}
}
send "\r"
expect eof

EOF


docker push mangseng/nodeappk8s:v$2
