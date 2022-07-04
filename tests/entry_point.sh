#!/usr/bin/env bash

#==============================================
# OpenShift or non-sudo environments support
# https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines
#==============================================

AIRFLOW_COMMAND="${@}"

echo ${AIRFLOW_COMMAND}

function kill_all_process(){
    (ps -x --sort=-pid | awk 'NR>1{print $1}' | xargs kill ) || ( echo "I am called" && exit 0)
}

( echo "start airflow command" && (/usr/bin/dumb-init -- /entrypoint ${AIRFLOW_COMMAND}) && sleep 20 && kill_all_process ) & ( echo "start supvisord" && /usr/bin/supervisord --configuration /etc/supervisord.conf ) 