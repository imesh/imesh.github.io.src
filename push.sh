#!/bin/bash

time=`date`
git add -A
git commit -m "rebuilding site ${time}"
git push origin master

pushd public
git add -A
git commit -m "rebuilding site ${time}"
git push origin master
popd
