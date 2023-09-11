#!/bin/bash

function usage {
cat <<'USAGE'
Maven Starter Script
====================

Usage:
	./start.sh <name> [<type>]
	
	name = short name name of application, without spaces
	type = Type of Maven project (optional), options are
		simple: Barebones with a placeholder POM and a single src/main/java folder
		standard: (default) Barebones Java-Maven3 project with placecholder POM
USAGE
}

if [ $# -eq 0 ]; then
	usage
	exit 1
fi

PROJECT=$1
TYPE=$2
if [ -n $TYPE ]; then
	TYPE="simple"
fi

git --version
IS_GIT=($? -eq 0)

if [ $IS_GIT ]; then
	echo "Creating new Git repository"
	git init "${PROJECT}"
else
	echo "Git is not available, proceeding without it."
fi

echo "Creating new Maven project ${PROJECT}"
mkdir -p "${PROJECT}/src/main/java"
mkdir -p "${PROJECT}/src/test/java"
mkdir -p "${PROJECT}/src/main/resources"
mkdir -p "${PROJECT}/src/test/resources"

if [ $IS_GIT ]; then
	touch "${PROJECT}/src/main/resources/.gitkeep"
	touch "${PROJECT}/src/test/resources/.gitkeep"
	touch "${PROJECT}/src/main/java/.gitkeep"
	touch "${PROJECT}/src/test/java/.gitkeep"
fi

(
cat <<EOF
<project xmlns="http://maven.apache.org/POM/4.0.0" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
		http://maven.apache.org/maven-v4_0_0.xsd">

  <modelVersion>4.0.0</modelVersion>

  <groupId>${PROJECT}</groupId>
  <artifactId>${PROJECT}</artifactId>
  <packaging>jar</packaging>
  <version>1.0-SNAPSHOT</version>
  
  <name>Replace for ${PROJECT}</name>
</project>
EOF
) > "${PROJECT}/pom.xml"

if [ $IS_GIT ]; then
	echo "Adding files to Git and committing"
	cd "${PROJECT}"
	git add -A
	git commit -m "Initial commit for ${PROJECT}, ${TYPE} Maven project"
	cd ..
fi