if "%BinDir%" == "" set BinDir=%~dp0/../Out

:: tools\build\src\engine\guess_toolset.bat负责查找VS编译器的路径(通过"VS***COMNTOOLS"、"VS_ProgramFiles"查找)，当前的boost版本只支持到VS2017
:: tools\build\src\engine\config_toolset.bat调用vcvarsall.bat(Call_If_Exists)设置编译环境
:: 这里手工设置为2019的编译器的路径(实际上应该是借用的VS2017的配置)

::set VS150COMNTOOLS=D:\DevTool\VS2019\Common7\Tools

if not exist "boost_1_64_0" (
    ../dev-bin/7z x boost_1_64_0.7z -o. ^
        boost_1_64_0\boost\ ^
        boost_1_64_0\libs\ ^
        boost_1_64_0\tools\ ^
        boost_1_64_0\*.jam ^
        boost_1_64_0\*.bat ^
        boost_1_64_0\Jamroot
)

pushd boost_1_64_0

if not exist "b2.exe" (
    del bootstrap.log 2>nul
    del project-config.jam 2>nul
    del *.exe 2>nul

    call bootstrap.bat
)

::不同的编译选项会影响最终生成文件的名字
::详见boost\config\auto_link.hpp中的代码
::当前配置下，因为编译的是动态库(link=shared)，在主程序中，需要定义BOOST_ALL_DYN_LINK宏，才能正确查找到lib文件

::Debug编译
::b2 --prefix="%BinDir%/ind" --exec-prefix="%BinDir%/dep" --libdir="%BinDir%/lib" --includedir="%BinDir%/include" ^
::    --stagedir="%BinDir%/stage" --build-dir="%BinDir%/../Tmp" ^
::    variant=debug link=shared threading=multi runtime-link=shared

::Release编译
b2 --stagedir="%BinDir%" --build-dir="%BinDir%/../Tmp" ^
    variant=release link=shared threading=multi runtime-link=shared 1>"%BinDir%/boost.log" 2>"%BinDir%/boost_error.log"

popd
