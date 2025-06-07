ls -a
#$VERSION $APPID

case "$vbStudioEnvironmentName" in
    "ENV1")
        vbStudioEnvironmentName_val=$devVbStudioEnvironmentName_val
        vbStudioEnvironmentName_url=$devVbStudioEnvironmentName_url
        vbStudioEnvironmentServcUserName=$devVbStudioEnvironmentServcUserName
        vbStudioEnvironmentServcUserPassword=$devVbStudioEnvironmentServcUserPassword
        ;;
    "ENV2")
        vbStudioEnvironmentName_val=$env2VbStudioEnvironmentName_val
        vbStudioEnvironmentName_url=env2VbStudioEnvironmentName_url
        vbStudioEnvironmentServcUserName=$env2VbStudioEnvironmentServcUserName
        vbStudioEnvironmentServcUserPassword=$env2VbStudioEnvironmentServcUserPassword
        ;; 
    *)
        echo "Unknown environment!"
        exit 1
        ;;
esac

echo "vbStudioEnvironmentName_val: $vbStudioEnvironmentName_val"
echo "vbStudioEnvironmentName_url: $vbStudioEnvironmentName_url"
echo "vbStudioEnvironmentServcUserName: $vbStudioEnvironmentServcUserName"
echo "vbStudioEnvironmentServcUserPassword: $vbStudioEnvironmentServcUserPassword"

base64_encoded_value=$vbStudioEnvironmentServcUserPassword

# Decode the Base64-encoded value and store it in a variable
vbStudioEnvironmentServcUserPassword=$(echo "$base64_encoded_value" | base64 -d)

branch_rootURL_version=$(./gitCheckout.sh $vbStudioEnvironmentName_val $DEPLOYMENT_BRANCH $DO_DEPLOYMENT $APP_ID $APP_VERSION)

read -r branch rootURL version <<< "$branch_rootURL_version"

echo $branch $rootURL $version

git checkout $branch

chmod +x envScript.sh

./envScript.sh $vbStudioEnvironmentName_val $rootURL $version

cat settings/user-roles.json
cat settings/deployment-profiles.json
cat visual-application.json


cat Gruntfile.js
npm install

grunt vb-archive:sources --sources-zip-path=build/sources.zip vb-process-local --url=https://xxxxxxxxxxx.oraclecloud.com/<vbs name>/s/<project name>/compcatalog/0.2.0 --username=$vbStudioServiceUserName --password=$vbStudioServiceUserPasssword vb-package vb-archive:optimized --optimized-zip-path=build/built-assets.zip

grunt vb-credentials:transfer \
    --url=https://xxxxxxxxxxx.oraclecloud.com/<vbs name>/s/<project name>/vbdt/design \
    --username=$vbStudioServiceUserName \
    --password=$vbStudioServiceUserPasssword \
    --environment-name=$vbStudioEnvironmentName

grunt vb-deploy --url=$vbStudioEnvironmentName_url --username=$vbStudioEnvironmentServcUserName --password=$vbStudioEnvironmentServcUserPassword --id=$APP_ID --ver=$APP_VERSION --remoteProjectId=<project name> --publish=$isAppLive
