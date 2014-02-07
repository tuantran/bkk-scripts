#!/usr/bin/env bash

ENVIN=$1

GITHUB="git@github.com:amedia"
BKK0=(siam thonglo)
BKK1=(asoke)
BKK2=(silom)

V3APPS=(transition apay hanuman pocit puls frontgrabber zeeland zservices zmapfetcher)

function find_current_app() {
  APP=${PWD##*/}
  echo "building app $APP for $ENVIN"
}

function check_app_server() {
  echo "checking $APP for $ENVIN"
  for _SERVER in ${ENVIN[@]}
  do
    echo $_SERVER
  done
  for _APP in ${V3APPS[@]}
  do
    echo $_APP
  done
}

function build_java_app() {
    echo "running maven build for $APP..."
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

function upload_app() {
    echo "uploading app.."
    for _MY_SERVER in ${SERVERS[@]}
    do
        echo $_MY_SERVER
	scp /tmp/$APP-webapp.war $_MY_SERVER:/tmp
	ssh $_MY_SERVER sudo mv /tmp/$APP-webapp.war /usr/local/$APP/webapps 
	ssh $_MY_SERVER sudo /etc/init.d/$APP restart
    done

}

find_current_app
check_app_server
#build_java_app
#upload_app


