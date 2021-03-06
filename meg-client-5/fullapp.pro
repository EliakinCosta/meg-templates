QT += qml quick quickcontrols2

CONFIG += c++11

SOURCES += main.cpp \
    core.cpp \
    pluginloader.cpp \
    authpluginmanager.cpp \
    drawerpluginmanager.cpp \
    swipeviewpluginmanager.cpp \
    filterproxymodel.cpp \
    meglistmodel.cpp

RESOURCES += qml.qrc

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

QML_IMPORT_PATH += modules

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

linux:!android {
    pluginsDestinationPath = $$OUT_PWD/plugins
    # remove plugins directory before build
    exists($$pluginsDestinationPath) {
        QMAKE_PRE_LINK += rm -rf $$pluginsDestinationPath $$escape_expand(\\n\\t)
    }
    # copy plugins directory to application executable dir after build
    QMAKE_POST_LINK += $(COPY_DIR) $$PWD/plugins $$OUT_PWD
}

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


plugins.files = plugins
plugins.path = /assets/
INSTALLS += plugins

HEADERS += \
    core.h \
    pluginloader.h \
    authpluginmanager.h \
    drawerpluginmanager.h \
    swipeviewpluginmanager.h \
    filterproxymodel.h \
    meglistmodel.h
