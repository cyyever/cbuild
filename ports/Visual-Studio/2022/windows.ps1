cd $env:SRC_DIR
gsudo .\vs_community.exe --update --quiet --wait
gsudo .\vs_community.exe --wait --addProductLang En-us --addProductLang Zh-cn --addProductLang Zh-tw --passive --norestart --productId Microsoft.VisualStudio.Product.Community --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.ASAN --add Microsoft.Component.VC.Runtime.UCRTSDK --add Microsoft.VisualStudio.Component.VC.ATL --add Microsoft.VisualStudio.Component.Windows10SDK --add Microsoft.VisualStudio.VC.MSBuild.Llvm 
gsudo .\vs_community.exe update --wait --passive --norestart
