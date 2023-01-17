#!/bin/bash

SCRIPT_URLS=$1
BASIC_AUTHEN=$2
BASE_GIT=$3
REPO_URL=$4
BRANCH=$5
JOB_NAME=$6
TOKEN=$7
REPO_OWNER=$8
REPO_NAME=$9

mkdir files
for script in $SCRIPT_URLS; do
  wget -P files $script
done

git clone $REPO_URL
git checkout -b features/$JOB_NAME $BRANCH
mkdir -f scripts
mv files/* scripts/
git add .
git commit -m "Add script(s) for $JOB_NAME" .
git push

curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/pulls \
  -d "{\"title\":\"Automation Request for $JOB_NAME\",\"body\":\"Please review these changes!\",\"head\":\"features/$JOB_NAME\",\"base\":\"development\"}" > resp.json

pr_url=`cat resp.json | jq '.url'`
echo "PR_URL=$pr_url" >> $GITHUB_OUTPUT