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
    signal login()
    signal logout()    

    function clearSettings(){
        settings.authenticated = false
        settings.base64StringOfUserColonPassword = ""
        settings.authToken = ""
    }

    onLogin: {
        settings.authenticated = true        
        mainStack.push(core.pluginsDir() + "/conferences/conferences.qml")
    }

    onLogout: {
        clearSettings()
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

    Settings {
        id: settings
        property bool authenticated
        property string authToken
        property string base64StringOfUserColonPassword
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

    Component.onCompleted: {
        if (!settings.authenticated)
            mainStack.push("file://" + core.auth().pluginName + "/" + core.auth().mainPage)
        else
            mainStack.push("file://" + core.drawerPlugins()[0].pluginName + "/" + core.drawerPlugins()[0].mainPage)
    }
}
