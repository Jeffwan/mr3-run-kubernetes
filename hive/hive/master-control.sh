#!/bin/bash

#
# Copyright (C) 2018, POSTECH.
# All rights reserved.
#

DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR=$(readlink -f $DIR/..)
source $BASE_DIR/env.sh
source $BASE_DIR/common-setup.sh
source $TEZ_BASE_DIR/tez-setup.sh
source $MR3_BASE_DIR/mr3-setup.sh

LOCAL_MODE="kubernetes"

tez_setup_init
mr3_setup_init

mr3_setup_update_hadoop_opts $LOCAL_MODE

export CLASSPATH=$BASE_DIR/conf/*:$MR3_CLASSPATH:$TEZ_CLASSPATH:$CLASSPATH

CLASS=edu.postech.mr3.client.util.MasterControlK8s

exec $JAVA_HOME/bin/java $HADOOP_OPTS $CLASS "$@"

