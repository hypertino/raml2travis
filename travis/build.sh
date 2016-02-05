#! /bin/bash
set -e
sudo apt-get update && sudo apt-get install oracle-java8-installer
java -version

cd raml-java-parser-2
cp -rf ../pom-deploy.xml pom-deploy.xml
cp -rrf ../settings-deploy.xml settings-deploy.xml

openssl aes-256-cbc -k "$key_password" -in ../travis/inn-oss-public.enc -out ./inn-oss-public.asc -d
openssl aes-256-cbc -k "$key_password" -in ../travis/inn-oss-private.enc -out ./inn-oss-private.asc -d
ls -al

if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
    mvn versions:set -DnewVersion=0.0.$TRAVIS_BUILD_NUMBER
    mvn -f pom-deploy.xml --settings settings-deploy.xml install
else
    mvn -f pom-deploy.xml --settings settings-deploy.xml install
fi
