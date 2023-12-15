#!/bin/bash

# Get the list of all apps directories
apps=$(find apps -type f -name "*.py" -exec dirname {} \; | sed 's,^apps/,,')
# Loop through each app directory

for app in $apps; do

echo "apps/$app"

  # Check if the app directory has any changes
  if [ -n "$(git diff --name-only "apps/$app" | grep "apps/$app")" ]; then

    echo "Zipping $app"
    cd "apps/$app/" && zip -r "${app}_$(date +"%Y%m%d%H%M").zip" .

    echo "Uploading $app.zip to S3"
    aws s3 rm "s3://s3-landing-dev-lucas/apps/${app}/*"

    aws s3 cp "${app}_$(date +"%Y%m%d%H%M").zip" "s3://s3-landing-dev-lucas/apps/${app}/${app}_$(date +"%Y%m%d%H%M").zip"

    rm "${app}.zip"

    cd ../..
  fi

done
