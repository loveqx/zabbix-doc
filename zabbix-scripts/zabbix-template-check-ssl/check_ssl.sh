#/bin/bash
host=$1
port=$2
end_date=`openssl s_client -host $host -port $port -showcerts </dev/null 2>/dev/null |
          sed -n '/BEGIN CERTIFICATE/,/END CERT/p' |
      openssl x509 -text 2>/dev/null |
      sed -n 's/ *Not After : *//p'`
if [ -n "$end_date" ]
then
    end_date_seconds=`date '+%s' --date "$end_date"`
# dateָÁformat×·û¼䡣
    now_seconds=`date '+%s'`
    echo "($end_date_seconds-$now_seconds)/24/3600" | bc
fi
