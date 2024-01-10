#!/bin/bash

# Define the source and target repositories
source_repo="http://192.168.122.84:9001/"
target_repo="http://192.168.122.95:9001/"

# List all images in the source repository
images=$(curl -s "${source_repo}v2/_catalog" | jq -r '.repositories[]')

for image in $images; do
    tags=$(curl -s "${source_repo}v2/${image}/tags/list" | jq -r '.tags[]')
    echo $tags

    # Iterate through each tag and sync/tag/push
    for tag in $tags; do
        # Pull the source image
        docker pull "${source_repo}${image}:${tag}"

        # Tag the image with the new repository
        docker tag "${source_repo}${image}:${tag}" "${target_repo}${image}:${tag}"

        # Push the image to the target repository
        docker push "${target_repo}${image}:${tag}"
    done
done

echo "Sync completed successfully."

