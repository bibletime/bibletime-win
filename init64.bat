
SET Compiler=Visual Studio 17 2022
SET Arch=x64
SET Qt=C:/Qt/6.8.2/msvc2022_64
SET GIT_BRANCH_OR_TAG=origin/stable-3.1.1

cmake -G "%Compiler%" -A %Arch% -DQt_PREFIX=%Qt% -DBT_DOC_REV=%BT_DOC_REV% -DGIT_BRANCH_OR_TAG=%GIT_BRANCH_OR_TAG%  ..\bibletime-win

