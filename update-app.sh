#!/usr/bin/env bash

ENV=$1

GITHUB="git@github.com:amedia"

declare -A ENVS
ENVS[bkk0]="siam,thonglo"
ENVS[bkk1]="asoke"
ENVS[bkk2]="silom"

declare -A V3APPS
V3APPS[bkk0]="transition,apay,hanuman,pocit,puls,frontgrabber,hydra"
V3APPS[bkk1]="zservices,zeeland,zmapfetcher"

function find_current_app() {
  APP=${PWD##*/}
  echo "building app $APP for $ENV"
}

function check_app_server() {
  _V3APPS=(${V3APPS[$ENV]//,/ })
  for _APP in ${_V3APPS[@]} 
  do
    if [ $_APP == $APP ]
    then
	return 1
    fi
  done
  echo -e "Could not find app!!"
  exit 1
}


function get_servers() {
  SERVERS=(${ENVS[$ENV]//,/ }) 
  echo "found servers: "
  for _SERVER in ${SERVERS[@]} 
  do
    echo $_SERVER
  done
}


function build_java_app() {
    echo "running maven build for $APP in current folder"
    mvn -q clean install -Dmaven.test.skip
    echo "done!"

    if [ -e $APP-webapp/target/$APP.war ]
    then
        cp $APP-webapp/target/$APP.war /tmp/$APP-webapp.war 
    else
	if [ -e $APP-webapp/target/$APP-webapp.war ]
	then 
		cp $APP-webapp/target/$APP-webapp.war /tmp/$APP-webapp.war
	else
			echo -e "Could not find $APP.war or $APP-web.war, the script only support war update!"
        	exit 1
	fi
    fi

}

function update_app() {
    echo "uploading $APP"
    for _MY_SERVER in ${SERVERS[@]}
    do
        echo "server $_MY_SERVER"
	scp /tmp/$APP-webapp.war $_MY_SERVER:/tmp
	ssh $_MY_SERVER sudo mv /tmp/$APP-webapp.war /usr/local/$APP/webapps 
	ssh $_MY_SERVER sudo /etc/init.d/$APP restart
    done

}

find_current_app
get_servers
check_app_server
build_java_app
update_app
