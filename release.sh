#!/usr/bin/env sh

RELEASE_VERSION=$(echo $TRAVIS_COMMIT_MSG | grep -P '^Merge\spull\srequest\s.*\sfrom\s.*\/release-(v[\d.-]+$)' | grep -P -o 'release-(v[\d.-]+$)')

# Release merge if commit is a non-PR push into master from a release branch (<org>/<branch>:)
if [ "$TRAVIS_BRANCH" == "master" ] && [[ $RELEASE_VERSION ]]; then
  echo 'Release script found a release merge into master detected... running deploy for release $RELEASE_VERSION'

  # set vars for deploy task
  export DEPLOY=true
  export NEW_VERSION_ID=${RELEASE_VERSION}

  # detached head fix
  git checkout master && git pull origin master

  # release cycle, use [skip ci] in commit message to tell travis to not build
  mvn -B release:clean release:prepare release:perform -DscmCommentPrefix="[maven-release-plugin][skip ci] "

  if [ $? -ne 0 ]; then
     echo "Error: mvn release cycle"
     exit $?
  fi

  # cut the next release branch
  RELEASE_PREFIX="release-v"
  NEXT_RELEASE_VERSION=$(cat pom.xml | grep -P "<version>.*</version>" | head -n 1 |  tr -d "[:space:]" | sed -e 's/<\(\/\)\{0,1\}version>//g' | sed -e 's/-SNAPSHOT//g')
  RELEASE_BRANCH=${RELEASE_PREFIX}${NEXT_RELEASE_VERSION}

  git checkout -B $RELEASE_BRANCH && git push origin $RELEASE_BRANCH

  if [ $? -ne 0 ]; then
     echo "Error: git post branch cut"
     exit $?
  fi

elif [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "Release script found a pull request, skipping..."
else
  echo "Release script found a regular build, marking snapshot build..."
  export DEPLOY=true
  export NEW_VERSION_ID=$(cat pom.xml | grep -P "<version>.*</version>" | head -n 1 |  tr -d "[:space:]" | sed -e 's/<\(\/\)\{0,1\}version>//g')

  # replace with your snapshot deploy call!
  mvn deploy

  if [ $? -ne 0 ]; then
     echo "Error: mvn deploy error"
     exit $?
  fi
fi