#!/bin/sh

# Script: delete_nexus_component.sh
#
# Auteur: Khadim MBACKE
# Date : 15/09/2023
#
# Description: This program allows you to delete one or more nexus components
#

. "/common.sh"

trap ctrlC INT

found=false

getLength(){
  curl --silent "http://$NEXUS_DNS:$NEXUS_PORT/service/rest/v1/search?repository=$REPO&format=$FORMAT&keyword=$KEYWORD$EXTRA_SEARCH" > /tmp/get.json
  realLength=$(cat /tmp/get.json | jq -c '.items | length')
}

getHttpReponse(){
    serverRespCode=$(curl -u $1 -X $2  --silent --fail $3 --write-out "%{http_code}\n" --output /dev/null)

    if [ $serverRespCode -eq 200 ]; then
        serverResponse=TRUE
    elif [ $serverRespCode -eq 404 ]; then
        serverResponse=NOTFOUND
    elif [ $serverRespCode -eq 401 ]; then
        serverResponse=NOTAUTHORIZED
    elif [ $serverRespCode -eq 40 ]; then
        serverResponse=NOTAUTHORIZED
    else
        serverResponse=$serverRespCode
    fi

   echo $serverResponse
}


checkauth() {
  serveurResponse=$(getHttpReponse "$USER:$PASSWORD" "GET" "http://$NEXUS_DNS:$NEXUS_PORT/service/rest/v1/search?repository=docker-public")
    if [ $serveurResponse != TRUE ]; then
      logError "The authentication provided $USER:$PASSWORD is not correct $serveurResponse."
      exit 1
    fi
}

doDelete(){
  tmpLength=$realLength
  for row in $(jq -c '.items | map(.) | .[]' /tmp/get.json); do
    _jq() {
      echo ${row} | jq -r "${1}"
    }
    curl --silent -u $USER:$PASSWORD -silent -X DELETE "http://$NEXUS_DNS:$NEXUS_PORT/service/rest/v1/components/$(_jq '.id')" >/dev/null 2>&1
    idx=$((idx + 1))
    logSuccess "Removed $idx/$realLength id = $(_jq '.id') | name = $(_jq '.name') | release | $(_jq '.version')"
  done
  if [ $idx -lt $tmpLength ]; then
      curl --silent "http://$NEXUS_DNS:$NEXUS_PORT/service/rest/v1/search?repository=$REPO&format=$FORMAT&keyword=$KEYWORD$EXTRA_SEARCH" > /tmp/get.json
      getLength
      if [ $tmpLength -gt 0 ]; then
        lot=$((lot + 1))
        logInfo "Deleting batch $lot..."
        doDelete
      fi
  fi
}

getLength

if [ $realLength -gt 0 ]; then
  logInfo "$realLength components found:"
  if $DELETE
   then
    logInfo "To remove these components, please authenticate to Nexus"
    printf "Please enter your Nexus username : "
    read USER
    printf>&2 "Please enter your Nexus password :"
    IFS= read -sr PASSWORD
    echo ""

    if ! [ -z $USER ] && ! [ -z $PASSWORD ]; then
      checkauth $USER $PASSWORD
      logInfo "Authentication successful for $USER"
      logWarn "Removed $realLength components. Do you want to continue ?"

      echo      "                                                                                                                      "
      echo -e   "             ┌──────────────────────────────────┐                   ┌──────────────────────────────────┐              "
      echo -e   "                   \e[92mENTER TO CONTINUE\e[0m                                  \e[91mCRTL + C TO CANCEL\e[0m "
      echo -e   "             └──────────────────────────────────┘                   └──────────────────────────────────┘              "
      echo -e   "                                                                                                                      "
      echo      " └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘"
      read -n 1 key
      idx=0
      lot=1
      if [ "$key" = "" ]; then
        logInfo "Deleting batch $lot..."
        doDelete
      else
        ctrlC
      fi
    else
      logError "No authentication provided."
      ctrlC
    fi
  else
    for row in $(jq -c '.items | map(.) | .[]' /tmp/get.json); do
          _jq() {
           echo ${row} | jq -r "${1}"
          }
         logInfo "                Found: id = $(_jq '.id') | name = $(_jq '.name') | version | $(_jq '.version')"
         found=true
      done

      if $found
      then
        logInfo "To delete these $realLength components, run the script again with --delete"
      fi
  fi
else
  logInfo "No components found!"
fi