mkdir -ErrorAction Ignore ${env:GOPATH}/src
mkdir -ErrorAction Ignore ${env:GOPATH}/bin
mkdir -ErrorAction Ignore ${env:GOPATH}/pkg

exit $lastexitcode
cd ${env:GOPATH}/src
mkdir -ErrorAction Ignore golang.org/x
cd golang.org/x
foreach($google_package in ("crypto","text","image","net","tools","sys","lint"))
{
  if(!(Test-Path -Path  ${google_package}))
{
    git clone --recurse-submodules "git@github.com:golang/${google_package}"
}
}
exit $lastexitcode
