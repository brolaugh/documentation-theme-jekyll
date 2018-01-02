#!/bin/bash
find _site -type f -exec curl -v --ftp-create-dirs -T {} -u $AZURE_WA_USERNAME:$AZURE_WA_PASSWORD $AZURE_WA_SITE/site/wwwroot/{} \;
