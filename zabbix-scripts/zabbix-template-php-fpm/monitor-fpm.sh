#!/bin/bash
pool(){
     curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/pool/ {print $NF}'
}        
process_manager() {        
    curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/process manager/ {print $NF}'
}  

start_since(){
    curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^start since:/ {print $NF}'
}
accepted_conn(){
    curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^accepted conn:/ {print $NF}' 
}
listen_queue(){     
    curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^listen queue:/ {print $NF}'
}
max_listen_queue(){
    curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^max listen queue:/ {print $NF}'
}
listen_queue_len(){  
    curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^listen queue len:/ {print $NF}'
}
idle_processes(){
   curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^idle processes:/ {print $NF}'
}
active_processes(){
    curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^active processes:/ {print $NF}'
}
total_processes(){
   curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^total processes:/ {print $NF}' 
}
max_active_processes(){
   curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^max active processes:/ {print $NF}'
}
max_children_reached(){
    curl -s http://127.0.0.1:8080/phpfpmstatus|awk '/^max children reached:/ {print $NF}' 
}
case "$1" in
pool)
pool
;;
process_manager)
process_manager
;;
start_since)
start_since
;;
accepted_conn)
accepted_conn
;;
listen_queue)
listen_queue
;;
max_listen_queue)
max_listen_queue
;;
listen_queue_len)
listen_queue_len
;;
idle_processes)
idle_processes
;;
active_processes)
active_processes
;;
total_processes)
total_processes
;;
max_active_processes)
max_active_processes
;;
max_children_reached)
max_children_reached
;;
*)
echo "Usage: $0 {pool|process_manager|start_since|accepted_conn|listen_queue|max_listen_queue|listen_queue_len|idle_processes|active_processes|total_processes|max_active_processes|max_children_reached}"
esac
