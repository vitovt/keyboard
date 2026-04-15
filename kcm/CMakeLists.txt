# SPDX-License-Identifier: BSD-3-Clause

set(QT_MAJOR_VERSION 6)
include(KDEInstallDirs6)

if(NOT CMAKE_LIBRARY_OUTPUT_DIRECTORY)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${KDE_INSTALL_PLUGINDIR}")
endif()

if(DEFINED BUILD_SHARED_LIBS)
    set(_maliit_kcm_had_build_shared_libs TRUE)
    set(_maliit_kcm_previous_build_shared_libs "${BUILD_SHARED_LIBS}")
else()
    set(_maliit_kcm_had_build_shared_libs FALSE)
endif()

# System Settings loads KCMs as plugins, so this target must stay loadable
# even though the main project defaults to static libraries.
set(BUILD_SHARED_LIBS ON)
kcmutils_add_qml_kcm(kcm_maliit)
if(_maliit_kcm_had_build_shared_libs)
    set(BUILD_SHARED_LIBS "${_maliit_kcm_previous_build_shared_libs}")
else()
    unset(BUILD_SHARED_LIBS)
endif()
unset(_maliit_kcm_had_build_shared_libs)
unset(_maliit_kcm_previous_build_shared_libs)

target_sources(kcm_maliit PRIVATE
    maliitkcm.cpp
    maliitkcm.h
    ${CMAKE_SOURCE_DIR}/src/plugin/keyboardsettings.cpp
    ${CMAKE_SOURCE_DIR}/src/plugin/keyboardsettings.h
    ${CMAKE_SOURCE_DIR}/src/3rdparty/QGSettings/qconftypes.cpp
    ${CMAKE_SOURCE_DIR}/src/3rdparty/QGSettings/qconftypes.h
    ${CMAKE_SOURCE_DIR}/src/3rdparty/QGSettings/qgsettings.cpp
    ${CMAKE_SOURCE_DIR}/src/3rdparty/QGSettings/qgsettings.h
    ${CMAKE_SOURCE_DIR}/src/3rdparty/QGSettings/util.cpp
    ${CMAKE_SOURCE_DIR}/src/3rdparty/QGSettings/util.h
)

target_include_directories(kcm_maliit PRIVATE
    ${CMAKE_SOURCE_DIR}/src/plugin
    ${CMAKE_SOURCE_DIR}/src/3rdparty
    ${GLib2_INCLUDE_DIRS}
    ${GIO_INCLUDE_DIRS}
)

target_link_libraries(kcm_maliit PRIVATE
    Qt6::Core
    Qt6::Qml
    Qt6::Quick
    KF6::CoreAddons
    KF6::I18n
    KF6::KCMUtilsQuick
    KF6::ConfigCore
    KF6::ConfigGui
    ${GIO_LIBRARIES}
)

target_compile_features(kcm_maliit PRIVATE cxx_std_17)

target_compile_definitions(kcm_maliit PRIVATE
    ${maliit-keyboard-definitions}
    QT_NO_KEYWORDS
)
