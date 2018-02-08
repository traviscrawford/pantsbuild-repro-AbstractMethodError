#!/bin/bash

set -x

echo "************************************************************************"
echo "Perform a clean build"
echo "************************************************************************"
rm -rf ./.cache/
rm -rf ./dist/
./pants clean-all

echo "************************************************************************"
echo "Build the binary"
echo "************************************************************************"
./pants binary src/main/scala/com/foo/myfancyjob:bin

echo "************************************************************************"
echo "RUN THE JAR: observe the `example` flag is shown in the help."
echo "************************************************************************"
java -cp dist/bin.jar com.foo.myfancyjob.MyFancyJob -h

echo "************************************************************************"
echo "Rename a flag in the base trait"
echo "************************************************************************"
sed -i '' 's/example/exampleRenamed/g' src/main/scala/com/foo/fancyjob/FancyJob.scala

echo "************************************************************************"
echo "Build incrementally"
echo "************************************************************************"
./pants binary src/main/scala/com/foo/myfancyjob:bin

echo "************************************************************************"
echo "Run the jar again. Observe it fails"
echo "************************************************************************"
java -cp dist/bin.jar com.foo.myfancyjob.MyFancyJob

echo "************************************************************************"
echo "Look in the class files and see both old/new flag name in different classes"
echo "************************************************************************"
cd dist/
unzip -q -o bin.jar
for x in $(find com/foo -name '*.class'); do echo $x; javap -v $x 2>&1 | grep example; done
