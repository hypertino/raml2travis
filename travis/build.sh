#! /bin/bash
set -e

cd raml-java-parser
cp -rf ../pom-parent.xml ./pom.xml
cp -rf ../pom-parser.xml ./raml-parser-2/pom.xml
cp -rf ../pom-yagi.xml ./yagi/pom.xml
cp -rf ../settings-deploy.xml ./settings-deploy.xml

echo "$key_password" | gpg --passphrase-fd 0 ../travis/ht-oss-public.asc.gpg
echo "$key_password" | gpg --passphrase-fd 0 ../travis/ht-oss-private.asc.gpg
gpg --dearmor ./ht-oss-public.asc
gpg --dearmor ./ht-oss-private.asc
ls -al
ls -al ./raml-parser-2/
ls -al ./yagi/

if [[ "$TRAVIS_PULL_REQUEST" == "false" && "$TRAVIS_BRANCH" == "master" ]]; then
#    mvn versions:set -DnewVersion=1.0.5.$TRAVIS_BUILD_NUMBER
    mvn clean install -DskipTests=true --settings=./settings-deploy.xml
    mvn deploy --settings=./settings-deploy.xml -P sonatype
else
    mvn clean install --settings=./settings-deploy.xml
fi
