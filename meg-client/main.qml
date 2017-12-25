import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Qt.labs.platform 1.0
import Components 1.0
import Awesome 1.0

ApplicationWindow {
    id: appWindow    

    property var stacks: []
    property alias currentIndex: swipeView.currentIndex
    property var currentStack: stacks[currentIndex]
    property QtObject currentPage : currentStack && currentStack.depth > 1 ? currentStack.currentItem : swipeView.currentItem.item    

    signal eventNotified(string eventName, var eventData)

    visible: true
    width: 360
    height: 640
    title: qsTr("MyApp")    

    Material.primary: "#05070d"
    Material.foreground: "#05070d"
    Material.accent: "#41cd52"

    FontLoader { id: fontAwesome; source: Qt.resolvedUrl("modules/Awesome/FontAwesome.otf") }

    QtObject {
        id: internal
        property string baseServer: "http://eliakimdjango.pythonanywhere.com"
    }

    Connections {
            target: appWindow
            onEventNotified: {
                if (eventName === "openDrawer"){
                    drawer.open()
                }
            }
    }

    header: CustomToolBar {
        id: toolbar
        width: parent.width
    }

    Drawer {
        id: drawer
        width: parent.width*2/3
        height: parent.height
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
                    text: "MyApp"
                    fontSizeMode: Text.HorizontalFit
                    font.pixelSize: width
                    font.family: "Roboto"
                    color: "white"
                }
            }
            ListView {
                width: parent.width
                height: 2 * (appWindow.height / 3)
                model: contents
                clip: true
                delegate: ItemDelegate {
                    width: parent.width
                    text: "         " + modelData.menuName

                    AwesomeToolButton {
                        text: FontAwesome.icons[modelData.icon]
                        enabled: false
                    }
                    onClicked: {
                        tabBar.currentIndex = index
                        drawer.close()
                    }
                }
            }
        }
    }


    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Repeater {
            model: contents

            Loader {
                source: (Qt.platform.os === "android") ?
                        "assets:/plugins/" + modelData.pluginName + "/" + modelData.mainPage
                        :
                        "file://" + modelData.pluginName + "/" + modelData.mainPage
            }
        }
    }

    footer: TabBar {
        id: tabBar
        width: parent.width
        currentIndex: swipeView.currentIndex
        Repeater {
            model: contents
            TabButton { text: modelData.menuName }
        }
    }
}
