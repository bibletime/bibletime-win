
project(bibletime-win) 
cmake_minimum_required(VERSION 3.17)
include(ExternalProject)
Set(CMAKE_CONFIGURATION_TYPES "Release" CACHE STRING "" FORCE) 
Set(BT_DOC_REV v3.1.1)
Set(PROJECT_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install) 



ExternalProject_Add(
    icu
    #URL https://github.com/unicode-org/icu/releases/download/release-76-1/icu4c-76_1-Win64-MSVC2022.zip
    URL https://github.com/unicode-org/icu/releases/download/release-74-2/icu4c-74_2-Win64-MSVC2019.zip
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND
	COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_BINARY_DIR}/icu-prefix/src/icu/include" "${PROJECT_INSTALL_DIR}/include"
	COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_BINARY_DIR}/icu-prefix/src/icu/bin64" "${PROJECT_INSTALL_DIR}/bin"
	COMMAND ${CMAKE_COMMAND} -E copy_directory "${PROJECT_BINARY_DIR}/icu-prefix/src/icu/lib64" "${PROJECT_INSTALL_DIR}/lib"
)



ExternalProject_Add(
    zlib
    URL https://github.com/madler/zlib/archive/v1.2.10.zip
    CMAKE_ARGS 
        -DCMAKE_INSTALL_PREFIX=${PROJECT_INSTALL_DIR}
        -DCMAKE_PREFIX_PATH=${PROJECT_INSTALL_DIR}
        -DCMAKE_BUILD_TYPE=Release
    CMAKE_CACHE_ARGS=
	"-DCMAKE_CXX_FLAGS=-Zc:wchar_t -DCMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} /UMBCS /D_UNICODE /DUNICODE"
)
ExternalProject_Get_Property(zlib BINARY_DIR)
Set(zlib_BINARY_DIR ${BINARY_DIR})
Set(zlib_INCLUDE_DIR ${PROJECT_INSTALL_DIR}/include)



ExternalProject_Add(
    curl
    URL https://github.com/curl/curl/releases/download/curl-7_70_0/curl-7.70.0.zip
    CMAKE_ARGS 
        -DCMAKE_INSTALL_PREFIX=${PROJECT_INSTALL_DIR}
        -DCMAKE_PREFIX_PATH=${PROJECT_INSTALL_DIR}
        -DBUILD_CURL_EXE=OFF
    CMAKE_CACHE_ARGS=
        "-DCMAKE_CXX_FLAGS=-Zc:wchar_t -DCMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} /UMBCS /D_UNICODE /DUNICODE"
        -DCMAKE_BUILD_TYPE=Release
)



ExternalProject_Add(
    clucene
      #  Fork of https://downloads.sourceforge.net/clucene/clucene-core-2.3.3.4.tar.gz
    GIT_REPOSITORY https://github.com/bibletime/clucene-win.git
    CMAKE_ARGS 
        -DCMAKE_INSTALL_PREFIX=${PROJECT_INSTALL_DIR}
        -DCMAKE_PREFIX_PATH=${PROJECT_INSTALL_DIR}
        -DDISABLE_MULTITHREADING=OFF
    CMAKE_CACHE_ARGS=
          -DZLIB_INCLUDE_DIR=${zlib_INCLUDE_DIR}
        "-DCMAKE_CXX_FLAGS=-Zc:wchar_t -DCMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} /UMBCS /D_UNICODE /DUNICODE"
        -DCMAKE_BUILD_TYPE=Release
    DEPENDS zlib
)
ExternalProject_Get_Property(clucene SOURCE_DIR)
Set(clucene_SOURCE_DIR ${SOURCE_DIR})
ExternalProject_Get_Property(clucene BINARY_DIR)
Set(clucene_BINARY_DIR ${BINARY_DIR})



ExternalProject_Add(
    sword
      #URL http://crosswire.org/ftpmirror/pub/sword/source/v1.8/sword-1.8.1.tar.gz
      #URL http://crosswire.org/ftpmirror/pub/sword/source/v1.9/sword-1.9.0.tar.gz
      #GIT_REPOSITORY https://github.com/bibletime/sword-win.git
    GIT_REPOSITORY https://github.com/bibletime/sword-1.9.0-win.git
      #SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../sword
    CMAKE_ARGS 
        -DCMAKE_INSTALL_PREFIX=${PROJECT_INSTALL_DIR}
        -DCMAKE_PREFIX_PATH=${PROJECT_INSTALL_DIR}
        -DLIBSWORD_LIBRARY_TYPE=Shared
        -DSWORD_NO_BZIP2=Yes
        -DCURL_INCLUDE_DIR="${PROJECT_INSTALL_DIR}"
        -DCURL_LIBRARY=${PROJECT_INSTALL_DIR}/lib/libcurl_imp.lib
    CMAKE_CACHE_ARGS=
	-DSWORD_SWIG_BINDINGS=OFF
	-DSWORD_BUILD_UTILS=No
	-DSWORD_BUILD_EXAMPLES=OFF
	-DSWORD_BUILD_TESTS=OFF
        "-DCMAKE_CXX_FLAGS=-Zc:wchar_t -DCMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} /UMBCS /D_UNICODE /DUNICODE"
        -DCLucene_INCLUDE_DIR=${clucene_SOURCE_DIR}/src/core
	-DCLucene_LIBRARY_DIR=${PROJECT_INSTALL_DIR}/include
        -DCLucene_LIBRARY=${clucene_BINARY_DIR}/bin/Release/clucene-core.lib
        -DCMAKE_BUILD_TYPE=Release
    DEPENDS curl zlib clucene icu 
)
ExternalProject_Get_Property(sword SOURCE_DIR)
Set(sword_SOURCE_DIR ${SOURCE_DIR})
ExternalProject_Get_Property(sword BINARY_DIR)
Set(sword_BINARY_DIR ${BINARY_DIR})



ExternalProject_Add(
    bibletime-docs
    GIT_REPOSITORY https://github.com/bibletime/generated_docs.git
    GIT_TAG master
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)
ExternalProject_Get_Property(bibletime-docs SOURCE_DIR)
Set(bibletime-docs_SOURCE_DIR ${SOURCE_DIR})
MESSAGE(STATUS  "docs: ${bibletime-docs_SOURCE_DIR}" )


ExternalProject_Add(
    bibletime
    GIT_REPOSITORY https://github.com/bibletime/bibletime.git
    GIT_TAG 9b6b5fef799ca654352e5efa6fe6a0af6fbbfe37

    #SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../bibletime
    #GIT_TAG ${GIT_BRANCH_OR_TAG} 
    #GIT_TAG master 
    #URL https://github.com/bibletime/bibletime/archive/v3.1.1.zip

    CMAKE_ARGS 
        -DCMAKE_INSTALL_PREFIX=${PROJECT_INSTALL_DIR}
        -DCMAKE_PREFIX_PATH=${PROJECT_INSTALL_DIR}
	-DBUILD_HANDBOOK_HTML=OFF
	-DBUILD_HANDBOOK_PDF=OFF
	-DBUILD_HOWTO_HTML=OFF
	-DBUILD_HOWTO_PDF=OFF
	-DINSTALL_GENERATED_DOCS=ON
    CMAKE_ARGS -D CMAKE_BUILD_TYPE=Release
    CMAKE_CACHE_ARGS=
	"-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} /UMBCS /D_UNICODE /DUNICODE"
        -DGENERATED_DOCS_DIR=${bibletime-docs_SOURCE_DIR}/docs/${BT_DOC_REV}
	-DCMAKE_PREFIX_PATH=${Qt_PREFIX}
	-DFindSword_LIBS=${sword_BINARY_DIR}/Release/sword.lib
	-DFindSword_INCS=${PROJECT_INSTALL_DIR}/include
        -DCLucene_SHARED_LIB=${clucene_BINARY_DIR}/bin/Release/clucene-shared.lib
        -DCLucene_INCLUDE_DIR=${clucene_SOURCE_DIR}/src/core
	-DCLucene_LIBRARY_DIR=${PROJECT_INSTALL_DIR}/include
        -DCLucene_LIBRARY=${clucene_BINARY_DIR}/bin/Release/clucene-core.lib
	-DCURL_LIBRARY=${PROJECT_INSTALL_DIR}/bin/libcurl.dll
	-DZLIB_LIBRARY_RELEASE=${zlib_BINARY_DIR}/Release/zlib.dll
	-DQT_WINDEPLOYQT_EXECUTABLE=${Qt_PREFIX}/bin/windeployqt.exe
	#-DPKG_CONFIG_EXECUTABLE:FILEPATH=C:/bibletime/windows/pkg-config-lite-0.28-1/bin/pkg-config.exe
	-DMSVC_REDIST=${MSVC_REDIST}
        -DCMAKE_BUILD_TYPE=Release
	-DCMAKE_CONFIGURATION_TYPES=${CMAKE_CONFIGURATION_TYPES} 
    INSTALL_COMMAND
        ${CMAKE_COMMAND} --build . --config Release --target install
        COMMAND ${CMAKE_COMMAND} --build . --config Release --target PACKAGE
    DEPENDS sword clucene zlib curl bibletime-docs icu
)
Link_Directories(${CMAKE_BINARY_DIR}/install/lib)

MESSAGE(STATUS  "Qt: ${Qt_PREFIX}" )
MESSAGE(STATUS  "Microsoft Redist: ${MSVC_REDIST}" )

