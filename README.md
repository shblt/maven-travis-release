# maven-travis-release 

Skeleton build/release process with Travis CI + Maven. 

## Purpose

This example implementation automates the release branch cut/creation process using the maven release plugin, and enables artifact  deployment from Travis.

## Implementation

## Branches

The branching model roughly follows [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/) where the *develop* branch is also the release branch, and named *"release-v<VERSION>"*. Branch structure: 

 - **master** 
   - Deployed production code. Should always be deployable from any commit. 
 - **release-vX.Y.Z**
   - Sprint long (or shorter) lived parent branch. It should contain only completed features and should be ready to be merged into master at anytime for a deploy.
 - **feature**
   - Developer branches for features and bug fixes. Merged into release and each merge should contain a single completed feature. 
 - **hotfix/bugfix**
   - Short lived branches for production issue or critical bug fixes. Created by branching master and then pushing to the current release branch. 
 
## Cycle

![png](https://github.com/shblt/maven-travis-release-depoyment/blob/master/diagram.png)

**Note:** When merging release branch into master use *"Create a merge commit"* in GitHub. "Squash and merge" will not work since `RELEASE_VERSION` is set using the standard "Merge pull request #X from org/branch" commit message.

## Components

### pom.xml

Configure the SCM, release plugin and distribution management repositories in the POM file. The version tag is used for git tagging and the release branch version should match. 

```xml
<project ...>
    ...
    <version>0.0.2-SNAPSHOT</version>
    <properties>
        ...
        <maven.repository>file://${basedir}/build/</maven.repository>
    </properties>
    ...
    <scm>
        <connection>scm:git:ssh://git@github.com/organization/repository.git</connection>
        <developerConnection>scm:git:ssh://git@github.com/organization/repository.git</developerConnection>
        <url>http://github.com/organization/repository</url>
        <tag>HEAD</tag>
    </scm>
    ...
    <build>
        <plugins>
            ...
            <plugin>
                <artifactId>maven-release-plugin</artifactId>
                <version>2.5.2</version>
            </plugin>
        </plugins>
    </build>
    <distributionManagement>
        <repository>
            <id>maven-repository</id>
            <name>local</name>
            <url>${maven.repository}</url>
        </repository>
    </distributionManagement>
</project>
```

### .travis.yml

Ensure building on the release branch is enabled and that the `release.sh` script is ran.
```yml
branches:
  only:
  - master
  - "/^release-v[\\d.-]+$/"
language: java
jdk:
  - oraclejdk8
before_install:
- git config --global user.name "Travis CI"
- git config --global user.email "builder@travis-ci.com"
- export TRAVIS_COMMIT_MSG="$(git log --format=%B -n 1 | head -n 1)"
# release script after build
after_success:
- "./release.sh"
```

### Travis SSH Key

Generate and add a SSH key to Travis under project [b]Settings[/b] or use the travis gem ([ref](http://stackoverflow.com/questions/27444891/how-to-add-ssh-key-in-travis-ci)). The below will work for travis-ci.com. If using travis-ci.org, a deploy key must be manually created, added to GitHub and configured in `.travis.yml`. See [Private Dependencies](https://docs.travis-ci.com/user/private-dependencies/).

```bash
gem install travis
travis login --pro
travis sshkey --generate
```

### Release Script

See the comments in [release.sh](https://github.com/shblt/maven-travis-release-depoyment/blob/master/release.sh).
