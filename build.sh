lambdas=$(find apps -type f -name "*.py" -exec dirname {} \; | sed 's,^apps/,,')

for lambda in $lambdas; do
  echo "Processing lambda: $lambda"

  # Zip the code without including the parent directory
  cd "apps/${lambda}/" && zip -r "${lambda}.zip" .

  # Output the content of the zip file for debugging
  unzip -l "${lambda}.zip"

  # Upload to S3 with the correct path
  aws s3 cp "${lambda}.zip" "s3://s3-landing-dev-lucas/apps/${lambda}/${lambda}.zip"

  # Optional: Remove the local zip file if needed
  rm "${lambda}.zip"

  cd ../..
done