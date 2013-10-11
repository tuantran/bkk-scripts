#!/usr/bin/env bash

GITHUB="git@github.com:amedia"

function build_java_app() {
    _APP=$1

    echo "running maven build for $_APP..."
    mvn -q clean install -Dmaven.test.skip
    echo "done!"
    git_version=`git log --pretty=format:%h -1`

    if [ -e $_APP-app/target/$_APP.zip ]
    then
        cp $_APP-app/target/$_APP.zip /tmp/$_APP-app-$git_version.zip 
    else
        echo -e "${WhiteF}[${RedF}ERROR${WhiteF}]${Reset} Could not find $_APP.zip. Must exit"
        exit 1
    fi

    V3_REVISION=$git_version
    upload $_APP /tmp/$_APP-app-$git_version.zip $version
}
