#!/usr/bin/env bash
NAME=$1
if [ "${NAME}" == "" ]
then
    NAME="AiClient-ios-unsigned"
fi

# 获取版本号
VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //')
# 移除版本号中的+号及之后的内容（如果有）
VERSION=$(echo $VERSION | sed 's/+.*//')

echo "版本号: $VERSION"
echo '正在使用 Flutter 进行构建'

######### Sign #########
# flutter build ios

######### No sign #########
flutter build ios --no-codesign

######### build #########
mkdir -p Payload
mkdir -p dist
mv ./build/ios/iphoneos/Runner.app Payload
zip -r -y Payload.zip Payload/Runner.app
mv Payload.zip ./dist/${VERSION}/${NAME}-v${VERSION}.ipa
rm -Rf Payload