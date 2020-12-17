cd $env:displaypath
if (git config --get remote.origin.url | Select-String -Pattern "cyyever\/cmake" -Quiet)
{
  git checkout master 
    git pull 
    cd $env:toplevel
    if (git commit -m "update cmake to master" $env:sm_path)
    {
      git push
    }
}
