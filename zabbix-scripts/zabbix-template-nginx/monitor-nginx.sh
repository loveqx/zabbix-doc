#!/bin/bash

function active {
                curl -s "http://127.0.0.1:8080/nginxstatus" | grep 'Active' | awk '{print $3}'
}
function reading {
                curl -s "http://127.0.0.1:8080/nginxstatus" | grep 'Reading' | awk '{print $2}'
}
function writing {
                curl -s "http://127.0.0.1:8080/nginxstatus" | grep 'Writing' | awk '{print $4}'
}
function waiting {
                curl -s "http://127.0.0.1:8080/nginxstatus" | grep 'Waiting' | awk '{print $6}'
}
function accepts {
                curl -s "http://127.0.0.1:8080/nginxstatus" | awk NR==3 | awk '{print $1}'
}
function handled {
                curl -s "http://127.0.0.1:8080/nginxstatus" | awk NR==3 | awk '{print $2}'
}
function requests {
                curl -s "http://127.0.0.1:8080/nginxstatus" | awk NR==3 | awk '{print $3}'
}



case "$1" in
active)
active
;;
reading)
reading 
;;
writing)
writing 
;;
waiting)
waiting 
;;
accepts)
accepts 
;;
handled)
handled 
;;
requests)
requests
;;
*)
 echo "Usage: $0 {active|reading|writing|waiting|accepts|handled|requests}"
esac
