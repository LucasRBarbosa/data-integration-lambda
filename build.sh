#!/bin/bash

git fetch --prune --unshallow

# Store the timestamp in a variable
timestamp="$1" 

# Check if it's a pull request and get the associated branch
if [[ "$GITHUB_EVENT_NAME" == "pull_request" ]]; then
  base_ref=$(jq -r .pull_request.base.ref "$GITHUB_EVENT_PATH")
  head_ref=$(jq -r .pull_request.head.ref "$GITHUB_EVENT_PATH")
fi

# Fetch changes from both branches
git fetch origin $base_ref
git fetch origin $head_ref

# Get the list of all apps directories
apps=$(find apps -type f -name "*.py" -exec dirname {} \; | sed 's,^apps/,,')
# Loop through each app directory

for app in $apps; do

echo "apps/$app"

  # Check if the app directory has any changes
  if [ -n "$(git diff --name-only origin/$current_ref "apps/$app" | grep "apps/$app")" ]; then

    echo "Zipping $app"
    cd "apps/$app/" && zip -r "${app}_${timestamp}.zip" .

    echo "Uploading $app.zip to S3"
    # aws s3 rm "s3://s3-landing-dev-lucas/apps/${app}" --recursive --include "*"

    aws s3 cp "${app}_${timestamp}.zip" "s3://s3-landing-dev-lucas/apps/${app}/${app}_${timestamp}.zip"

    rm "${app}_${timestamp}.zip"

    cd ../..

    if 

  fi

done
