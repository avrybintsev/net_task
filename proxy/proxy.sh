#!/bin/bash

for param in "$@"
do
	if [ "$param" == "--help" ]
	then
		echo "Simple sniffer @localhost"
		echo "in_port: param1, out_port: param2, log_file: param3"
		exit 0
	fi
done

close()
{
	rm pipe
	exit 0
}

trap close SIGINT

in_port=$1
out_port=$2
log_file=$3

if [ ! $in_port ]
then
	in_port=1234
fi

if [ ! $out_port ]
then 
	out_port=4321
fi

if [ ! $log_file ]
then
	log_file="log.txt"
fi

echo "sniffer @localhost"
echo "in_port: $in_port"
echo "out_port: $out_port"

mkfifo pipe

while true
do
	nc -l $in_port < pipe | tee -a $log_file | nc localhost $out_port | tee -a $log_file > pipe
done

