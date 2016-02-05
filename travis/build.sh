#! /bin/bash
set -e

cd raml-java-parser-2
ln -s ../pom-deploy.xml pom-deploy.xml
ln -s ../settings-deploy.xml settings-deploy.xml
ls -al

openssl aes-256-cbc -k "$key_password" -in ../travis/inn-oss-public.enc -out ./inn-oss-public.asc -d
openssl aes-256-cbc -k "$key_password" -in ../travis/inn-oss-private.enc -out ./inn-oss-private.asc -d


if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
  mvn -f pom-deploy.xml --settings settings-deloy.xml install
else
  mvn -f pom-deploy.xml --settings settings-deloy.xml install
fi
