#!/bin/bash
directory=docs
branch=gh-pages

build_command() {
  v run build.v
}

timestamp() {
  date +"%Y-%m-%dT%T"
}

echo -e "\033[0;32mBuilding site...\033[0m"
#build_command

echo -e "\033[0;32mDeploying $branch branch... ($(timestamp))\033[0m"
cd $directory &&
  git add --all &&
  git commit -m "Deploy updates [$(timestamp)]" &&
  git push origin $branch