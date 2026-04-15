# SPDX-License-Identifier: BSD-3-Clause

kcmutils_add_qml_kcm(kcm_maliit)

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
