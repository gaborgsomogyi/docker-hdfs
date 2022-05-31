#!/bin/bash

export JAVA_HOME=$(ls -d /usr/lib/jvm/java-1.8.0-openjdk*)
echo "Detected JAVA_HOME=${JAVA_HOME}"

echo "export JAVA_HOME=${JAVA_HOME}" >> "${HADOOP_HOME}/etc/hadoop/hadoop-env.sh"

cp /share/krb5.conf /etc

"${HADOOP_HOME}/bin/hdfs" namenode -format

service ssh start
"${HADOOP_HOME}/sbin/start-dfs.sh"

kinit -kt /share/hdfs.keytab hdfs@EXAMPLE.COM
"${HADOOP_HOME}/bin/hdfs" dfs -chmod 777 /
kdestroy

while true; do sleep infinity; done
