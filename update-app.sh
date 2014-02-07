#!/usr/bin/env bash

GITHUB="git@github.com:amedia"
SERVERS=(siam thonglo)

function find_current_app() {
     APP=${PWD##*/}
     echo "building app $APP"
}

function build_java_app() {
    echo "running maven build for $APP..."
    mvn -q clean install -Dmaven.test.skip
    echo "done!"
    #git_version=`git log --pretty=format:%h -1`

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

    #V3_REVISION=$git_version
    #upload $_APP /tmp/$_APP-app-$git_version.zip $version
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
build_java_app
upload_app


