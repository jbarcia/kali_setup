#!/bin/bash
# Script to update GitHub scripts

cd /root/github
find . -type d -mindepth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;
