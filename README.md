# maven-travis-release-depoyment
Skeleton build/release process with Travis CI + Maven


Boilerplate example of a system that automates a release branch cut/creation proession via the maven release plugin, and enables artifiact deployment via Travis. The branching model roughly follows [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/) where the deploy branch is named "release-v<VERSION>" (Ex. "release-vX.Y.Z") instead. 

Where version matches your pom version. 

Note: When merging release branch into master use "Create a merge commit" in GitHub. "Squash and merge" will not work since `RELEASE_VERSION` is set using the standard "Merge pull request..." commit message. 




https://docs.travis-ci.com/user/private-dependencies/#Deploy-Key

Deploy key with "Allow write access" enabled