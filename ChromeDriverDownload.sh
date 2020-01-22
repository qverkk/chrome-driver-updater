#! /bin/bash

CONTENTS=$(curl -L https://chromedriver.chromium.org/downloads)
GOOGLE_VERSION=""
MAJOR_VERSION=""
FILE_NAME=""
case $(uname) in 
    'Darwin')
        GOOGLE_VERSION=$(/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version)
        MAJOR_VERSION=`echo $GOOGLE_VERSION | egrep -o '[0-9]{1,3}' | head -1`
        FILE_NAME="chromedriver_mac64.zip"
    ;;
    'Linux')
        GOOGLE_VERSION=$(google-chrome --product-version)
        MAJOR_VERSION=`echo $GOOGLE_VERSION | egrep -o '[0-9]{1,3}' | head -1`
        FILE_NAME="chromedriver_linux64.zip"
        sudo apt-get update
        sudo apt-get install unzip -qy
    ;;
esac
ONLINE_DRIVER_VERSION=`echo $CONTENTS | egrep -o ''$MAJOR_VERSION'\.[0-9]{1,5}\.[0-9]{1,5}\.[0-9]{1,5}' | head -1`
DOWNLOAD_LINK='https://chromedriver.storage.googleapis.com/'$ONLINE_DRIVER_VERSION'/'$FILE_NAME''

FILE=~/Downloads/chromedriver
if [ -f "$FILE" ]; then
    CURRENT_DRIVER_VERSION=`cd ~/Downloads && ./chromedriver --version | egrep -o '[0-9]{1,5}' | head -1`
    echo "Major version: $MAJOR_VERSION"
    echo "Current version: $CURRENT_DRIVER_VERSION"
    if [ $MAJOR_VERSION -ne $CURRENT_DRIVER_VERSION ]; then
        echo "Versions not equal" && \
        echo "Removing..." && \
        cd ~/Downloads && rm chromedriver && \
        echo "Downloading..." && \
        curl -O $DOWNLOAD_LINK && unzip $FILE_NAME && \
        rm $FILE_NAME
    else
        echo "Versions are equal, you are good to go!"
    fi
else
    echo "You don't have chromedriver, downloading..."
    cd ~/Downloads && \
    curl -O $DOWNLOAD_LINK && \
    unzip $FILE_NAME && \
    rm $FILE_NAME
fi
