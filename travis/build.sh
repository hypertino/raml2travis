#! /bin/bash
set -e

cd raml-java-parser
cp -rf ../pom-parent.xml ./pom.xml
cp -rf ../pom-parser.xml ./raml-parser-2/pom.xml
cp -rf ../pom-yagi.xml ./yagi/pom.xml
cp -rf ../settings-deploy.xml ./settings-deploy.xml

openssl aes-256-cbc -k "$key_password" -in ../travis/inn-oss-public.enc -out ./inn-oss-public.asc -d
openssl aes-256-cbc -k "$key_password" -in ../travis/inn-oss-private.enc -out ./inn-oss-private.asc -d
gpg --dearmor ./inn-oss-public.asc
gpg --dearmor ./inn-oss-private.asc
ls -al
ls -al ./raml-parser-2/
ls -al ./yagi/

if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
    mvn versions:set -DnewVersion=1.0.1.$TRAVIS_BUILD_NUMBER
    mvn clean install -DskipTests=true --settings=./settings-deploy.xml
    mvn deploy -DskipTests=true --settings=./settings-deploy.xml
else
    mvn clean install --settings=./settings-deploy.xml
fi
