#!/bin/sh

# Script: common.sh
#
# Auteur: Khadim MBACKE
# Date : 15/09/2023
#
# Description: common functions
#

log () {
    level=$1
    shift
    col=
    case "$level" in
        'ERROR')
            col="\e[31m"
            icon="❌ "
            ;;
        'WARN')
            col="\e[33m"
            icon="⚠️  "
            ;;
        'DEBUG')
            col="\e[35m"
            ;;
        'INFO')
            col="\e[96m"
            icon="ℹ️  "
            ;;
        'SUCCESS')
          col="\e[32m"
          icon="✅ "
          ;;
    esac

    echo -e -n $(date +'%Y-%m-%d %H:%M:%S') " $level $col $icon"
    echo -e -n $*
    echo -e "\e[0m"
}

logInfo () {
    log INFO $*
}

logSuccess () {
    log SUCCESS $*
}

logWarn () {
    log WARN $*
}

logError () {
    log ERROR $*
}

#message log debug
logDebug () {
     log DEBUG $*
}

#message logN
logNE () {
    echo -ne "\e[32m ℹ: ${1}\e[0m"
}

failed() {
    if [ -z "$1" ]
    then
        logError 'Premature end of process: FAILURE!'
    else
        logError "Premature end of process: " $*
    fi

    exit 1
}

ctrlC() {
    echo ""
    logError "Program canceled by user"
    logInfo "See you soon !"
    exit
}

trap ctrlC INT