#!/bin/bash

git fetch --prune --unshallow

current_ref=$(echo $GITHUB_REF | sed 's/refs\/heads\///')

# Check if it's a pull request and get the associated branch
if [[ "$GITHUB_EVENT_NAME" == "pull_request" ]]; then
  current_ref=$(jq -r .pull_request.base.ref "$GITHUB_EVENT_PATH")
fi

# Get the list of all apps directories
apps=$(find apps -type f -name "*.py" -exec dirname {} \; | sed 's,^apps/,,')
# Loop through each app directory

for app in $apps; do

echo "apps/$app"

  # Check if the app directory has any changes
  if [ -n "$(git diff --name-only origin/$current_ref "apps/$app" | grep "apps/$app")" ]; then

    echo "Zipping $app"
    cd "apps/$app/" && zip -r "${app}_$(date +"%Y%m%d%H%M").zip" .

    echo "Uploading $app.zip to S3"
    aws s3 rm "s3://s3-landing-dev-lucas/apps/${app}/*" --recursive --include "*"

    aws s3 cp "${app}_$(date +"%Y%m%d%H%M").zip" "s3://s3-landing-dev-lucas/apps/${app}/${app}_$(date +"%Y%m%d%H%M").zip"

    rm "${app}_$(date +"%Y%m%d%H%M").zip"

    cd ../..
  fi

done
