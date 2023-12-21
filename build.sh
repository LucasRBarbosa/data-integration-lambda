#!/bin/bash

# git fetch --prune --unshallow

# Store the timestamp in a variable
timestamp="$1" 

# Check if it's a pull request and get the associated branch. Check if the local flag is provided
if [ "$2" == "LOCAL" ]; then
  echo "Running in local mode"

  base_ref="main" 
  head_ref="bug/correct-build-script"
else
  # GitHub Actions environment variables
  base_ref="$GITHUB_BASE_REF"
  head_ref="$GITHUB_HEAD_REF"
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
  if [ -n "$(git diff --name-only origin/$base_ref...origin/$head_ref "apps/$app"  | grep "apps/$app")" ]; then

    echo "Zipping $app"
    cd "apps/$app/" && zip -r "${app}_${timestamp}.zip" .

    echo "Uploading $app.zip to S3"
    # aws s3 rm "s3://s3-landing-dev-lucas/apps/${app}" --recursive --include "*"

    aws s3 cp "${app}_${timestamp}.zip" "s3://s3-landing-dev-lucas/apps/${app}/${app}_${timestamp}.zip"

    # Log the name of the synced file
    echo "Updated: ${app}_${timestamp}.zip" >> ../../changed_files.log

    rm "${app}_${timestamp}.zip"

    cd ../..

  fi

done
