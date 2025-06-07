#!/bin/bash

profile=$1
branch=$2
doDeployment=$3
rootURL=$4
apprvlReq=$5
version=$6

if [ -z "$profile" ]; then
  echo "Profile is blank, exiting the script"
  exit 1
fi

if [[ -z "$branch" && -z "$doDeployment" && -z "$rootURL" && -z "$version" ]]; then
  # echo "Both branch and doDeployment are blank"
# Use the case statement to check the value of the profile
case $profile in
  env1)
      branch=$(jq -r '.dev.branch' branches_for_env.json)
      rootURL=$(jq -r '.dev.rootUrl' branches_for_env.json)
      version=$(jq -r '.dev.version' branches_for_env.json)
      doDeployment=$(jq -r '.dev.doDeployment' branches_for_env.json)
      apprvlReq=$(jq -r '.dev.apprvlReq' branches_for_env.json)
    
   ;;
  env2)
      branch=$(jq -r '.env2.branch' branches_for_env.json)
      rootURL=$(jq -r '.env2.rootUrl' branches_for_env.json)
      version=$(jq -r '.env2.version' branches_for_env.json)
      doDeployment=$(jq -r '.env2.doDeployment' branches_for_env.json)
      apprvlReq=$(jq -r '.env2.apprvlReq' branches_for_env.json)
    
   ;;
  *)
    echo "You entered a value that is not env1, env2"
    exit 1
    ;;
esac

fi

    shopt -s nocasematch

    if [[ "$doDeployment" == "Y" ]]; then

       echo $branch $rootURL $apprvlReq $version

    else
        echo "No Deployment, exiting the script"
        exit 1
    fi
