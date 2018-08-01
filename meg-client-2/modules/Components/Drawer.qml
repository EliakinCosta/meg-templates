import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Qt.labs.platform 1.0

import Awesome 1.0

Drawer {
    id: drawer
    width: parent.width*2/3
    height: parent.height
    dragMargin: settings.authenticated ? (Qt.styleHints.startDragDistance + 5) : 0

    Connections {
        target: appWindow
        onEventNotified: {
            if (eventName === "openDrawer") {
                drawer.open()
            }
        }
    }

    Column {
        anchors.fill: parent

        Rectangle {
            width: drawer.width
            height: appWindow.height / 3
            color: Material.primaryColor

            Label {
                width: drawer.width / 3 * 2
                height: contentHeight
                anchors { left: parent.left; leftMargin: 13; bottom: parent.bottom; bottomMargin: 5 }
                text: qsTr("fullApp")
                fontSizeMode: Text.HorizontalFit
                font.pixelSize: width
                font.family: "Roboto"
                color: "white"
            }
        }

        ListView {
            width: parent.width
            height: 2 * (appWindow.height / 3)
            model: core.drawerPlugins()
            clip: true
            delegate: ItemDelegate {
                width: parent.width
                text: "         " + modelData.menuName

                AwesomeToolButton {
                    text: FontAwesome.icons[modelData.icon]
                    enabled: false
                }
                onClicked: {
                    if (modelData.showInSwipeView) {
                        for (var index = 0; index < core.swipeViewPlugins().length; index++) {
                            if (modelData.pluginName === core.swipeViewPlugins()[index].pluginName) {
                                mainStack.push((Qt.platform.os === "android") ? "assets:/plugins/" + modelData.pluginName + "/" + modelData.mainPage : "file://" + modelData.pluginName + "/" + modelData.mainPage, {})
                            }
                        }
                    }
                    else {
                        appWindow.logout()
                    }
                    drawer.close()
                }
            }
        }
    }
}
