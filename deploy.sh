#!/bin/bash
if [ "$TRAVIS_BRANCH" == "master" ] && [  !$TRAVIS_PULL_REQUEST ]; then
  find _site -type f -exec curl --ftp-create-dirs -T {} -u $AZURE_WA_USERNAME:$AZURE_WA_PASSWORD $AZURE_WA_SITE/site/wwwroot/{} \;
fi