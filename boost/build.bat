if "%BinDir%" == "" set BinDir=%~dp0/../Out

:: tools\build\src\engine\guess_toolset.bat�������VS��������·��(ͨ��"VS***COMNTOOLS"��"VS_ProgramFiles"����)����ǰ��boost�汾ֻ֧�ֵ�VS2017
:: tools\build\src\engine\config_toolset.bat����vcvarsall.bat(Call_If_Exists)���ñ��뻷��
:: �����ֹ�����Ϊ2019�ı�������·��(ʵ����Ӧ���ǽ��õ�VS2017������)

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

::��ͬ�ı���ѡ���Ӱ�����������ļ�������
::���boost\config\auto_link.hpp�еĴ���
::��ǰ�����£���Ϊ������Ƕ�̬��(link=shared)�����������У���Ҫ����BOOST_ALL_DYN_LINK�꣬������ȷ���ҵ�lib�ļ�

::Debug����
::b2 --prefix="%BinDir%/ind" --exec-prefix="%BinDir%/dep" --libdir="%BinDir%/lib" --includedir="%BinDir%/include" ^
::    --stagedir="%BinDir%/stage" --build-dir="%BinDir%/../Tmp" ^
::    variant=debug link=shared threading=multi runtime-link=shared

::Release����
b2 --stagedir="%BinDir%" --build-dir="%BinDir%/../Tmp" ^
    variant=release link=shared threading=multi runtime-link=shared 1>"%BinDir%/boost.log" 2>"%BinDir%/boost_error.log"

popd
