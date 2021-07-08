exit 0
cd $env:SRC_DIR
start-process -Wait -verb runAs vs_community.exe -argumentlist "--update --quiet --wait"
start-process -Wait -verb runAs vs_community.exe -argumentlist "--wait --addProductLang En-us --addProductLang Zh-cn --addProductLang Zh-tw --passive --norestart --productId Microsoft.VisualStudio.Product.Community --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.VC.ASAN --add Microsoft.Component.VC.Runtime.UCRTSDK --add Microsoft.VisualStudio.Component.VC.ATL --add Microsoft.VisualStudio.Component.Windows10SDK --add Microsoft.VisualStudio.VC.MSBuild.Llvm"
start-process -Wait -verb runAs vs_community.exe -argumentlist "update --wait --passive --norestart"
