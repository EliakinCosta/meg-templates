import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Qt.labs.settings 1.0

import Components 1.0 as Components
import Awesome 1.0

ApplicationWindow {
    id: appWindow

    property QtObject currentPage: mainStack.currentItem
    property bool showDrawer: true

    signal eventNotified(string eventName, var eventData)
    signal login(var data)
    signal logout()

    onLogin: {
        settings.authenticated = true
        settings.authHeader = data.authHeader
        mainStack.push(core.pluginsDir() + "/conferences/conferences.qml")
    }

    onLogout: {
        settings.authenticated = false
        settings.authHeader = ({})
        mainStack.clear()
        mainStack.push("file://" + core.auth().pluginName + "/" + core.auth().mainPage)
    }

    visible: true
    width: 360
    height: 640
    title: qsTr("fullApp")

    Material.primary: "#05070d"
    Material.foreground: "#05070d"
    Material.accent: "#41cd52"

    FontLoader { id: fontAwesome; source: Qt.resolvedUrl("modules/Awesome/FontAwesome.otf") }

    QtObject {
        id: internal
//        property string baseServer: "http://eliakimdjango.pythonanywhere.com"
        property string baseServer: "http://127.0.0.1:5000"
    }

    Loader {
       id: toolbarLoader
       active: settings.authenticated
       source: Qt.resolvedUrl("modules/Components/CustomToolBar.qml")
       onStatusChanged: if (toolbarLoader.status === Loader.Ready) appWindow.header = toolbarLoader.item
       onActiveChanged: if (toolbarLoader.active === false) appWindow.header = null
    }

    Loader {
       id: drawerLoader
       active: showDrawer
       source: Qt.resolvedUrl("modules/Components/Drawer.qml")
    }    

    StackView {
        id: mainStack
        anchors.fill: parent
    }

    Settings {
        id: settings
        property bool authenticated
        property var authHeader
    }

    Component.onCompleted: {
        if (!settings.authenticated)
            mainStack.push("file://" + core.auth().pluginName + "/" + core.auth().mainPage)
        else
            mainStack.push("file://" + core.drawerPlugins()[0].pluginName + "/" + core.drawerPlugins()[0].mainPage)
    }
}
