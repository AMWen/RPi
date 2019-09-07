#!/bin/sh
swift package generate-xcodeproj
cat e16server.xcodeproj/project.pbxproj | sed s/10.10/10.13/g > tmp
mv tmp e16server.xcodeproj/project.pbxproj
