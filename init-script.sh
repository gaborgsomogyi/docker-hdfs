#!/bin/bash

cp /share/krb5.conf /etc

$HADOOP_HOME/bin/hdfs namenode -format

service ssh start
$HADOOP_HOME/sbin/start-dfs.sh

kinit -kt /share/hdfs.keytab hdfs@EXAMPLE.COM
$HADOOP_HOME/bin/hdfs dfs -chmod 777 /
kdestroy

while true; do sleep infinity; done
