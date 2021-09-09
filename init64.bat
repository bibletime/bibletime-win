
SET Compiler=Visual Studio 16 2019
SET Arch=x64
SET Qt=C:/Qt/5.15.2/msvc2019_64
SET GIT_BRANCH_OR_TAG=origin/stable-3.0.2

cmake -G "%Compiler%" -A %Arch% -DQt_PREFIX=%Qt% -DBT_DOC_REV=%BT_DOC_REV% -DGIT_BRANCH_OR_TAG=%GIT_BRANCH_OR_TAG%  ..\bibletime-win

