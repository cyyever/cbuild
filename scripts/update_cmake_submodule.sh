#!/bin/bash
set -eu
cd $displaypath
if git config --get remote.origin.url | grep -E 'cyyever\/cmake'
then
 git checkout master 
 git pull 
 cd $toplevel 
 if git commit -m "update cmake to master" $sm_path
 then 
   git push
 fi
fi
