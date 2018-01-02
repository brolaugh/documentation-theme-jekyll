#!/bin/bash
bundle install
bundle exec jekyll build
cd _site
find . -type f -exec curl --ftp-create-dirs -T {} -u $AZURE_WA_USERNAME:$AZURE_WA_PASSWORD $AZURE_WA_SITE/site/wwwroot/{} \;
