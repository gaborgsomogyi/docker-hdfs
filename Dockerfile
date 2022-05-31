FROM ubuntu:jammy

EXPOSE 9000

RUN apt-get -qq update
RUN apt-get -qq install curl ssh openjdk-8-jdk jsvc krb5-user
RUN apt-get -qq clean

ENV HADOOP_VERSION 3.3.3
ENV JSVC_HOME /usr/bin
ENV HADOOP_HOME /opt/hadoop

RUN \
  for user in hadoop hdfs user; do \
    useradd -U -m --shell /bin/bash ${user}; \
  done && \
  for user in hdfs user; do \
    usermod -G hadoop ${user}; \
  done

ADD ssh_config /root/.ssh/config
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

ADD --chown=hdfs:hdfs ssh_config /home/hdfs/.ssh/config
USER hdfs
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

USER root
RUN \
  curl -s https://dlcdn.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz | tar -xz -C /opt && \
  ln -s /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME

ADD *.xml $HADOOP_HOME/etc/hadoop/

RUN \
  mkdir -p $HADOOP_HOME/logs && \
  chmod 777 $HADOOP_HOME/logs

RUN \
  echo "export JSVC_HOME=$JSVC_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "export HDFS_NAMENODE_USER=hdfs" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "export HDFS_SECONDARYNAMENODE_USER=hdfs" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
  echo "export HDFS_DATANODE_SECURE_USER=hdfs" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

ADD init-script.sh /init-script.sh
ENTRYPOINT /init-script.sh
