#!/bin/bash

source ./scripts/setup.sh

echo
echo "Building $project_name for $author in $full_build_directory"
echo
bash scripts/build.sh "$project_name_directory" "$author" "$full_build_directory" "$github_url"

if [ $? -eq 0 ]; then
    echo
    echo "Successfully built files for $project_name"
    echo
else
    echo
    echo "Could not build files for $project_name" >&2
    echo "Cleaning up"
    echo
    rm -rf "$full_build_directory"
    exit 1
fi

echo
echo "Handling npm dependencies"
echo
bash scripts/npm.sh "$full_build_directory"

if [ $? -eq 0 ]; then
    echo
    echo "Successfully installed npm dependencies for $project_name"
    echo
else
    echo
    echo "Could not install npm dependencies for $project_name" >&2
    echo "Cleaning up"
    echo
    rm -rf "$full_build_directory"
    exit 1
fi


if [ ! -z "$github_url" ]; then

    echo
    echo "Pushing initial $project_name to Github at $github_url"
    echo
    bash scripts/github.sh "$full_build_directory" "$github_url"

    if [ $? -eq 0 ]; then
        echo
        echo "Successfully pushed $project_name to Github at $github_url"
        echo
    else
        echo
        echo "Could not push $project_name to Github at $github_url" >&2
        echo "Continuing"
        echo
    fi

fi


echo "Starting local development server"
cd $full_build_directory
echo "Enter the command <grunt> from this directory to start the server in the future"
grunt
